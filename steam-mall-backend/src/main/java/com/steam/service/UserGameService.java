package com.steam.service;

import com.steam.dto.GameReviewDto;
import com.steam.dto.GameReviewSummaryDto;
import com.steam.entity.Game;
import com.steam.entity.GameReview;
import com.steam.entity.User;
import com.steam.entity.UserGame;
import com.steam.repository.GameRepository;
import com.steam.repository.GameReviewRepository;
import com.steam.repository.UserGameRepository;
import com.steam.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserGameService {

    private final UserGameRepository userGameRepository;
    private final GameRepository gameRepository;
    private final GameReviewRepository gameReviewRepository;
    private final UserRepository userRepository;

    public List<UserGame> getUserLibrary(Long userId) {
        return userGameRepository.findByUserIdAndIsActivated(userId, 1);
    }

    public List<Game> getUserGames(Long userId) {
        List<Long> gameIds = userGameRepository.findGameIdsByUserId(userId);
        return gameRepository.findAllById(gameIds);
    }

    public boolean ownsGame(Long userId, Long gameId) {
        return userGameRepository.existsByUserIdAndGameIdAndIsActivated(userId, gameId, 1);
    }

    @Transactional
    public GameReview createReview(Long userId, Long gameId, Integer isPositive, String content) {
        if (!ownsGame(userId, gameId)) {
            throw new RuntimeException("只有游戏库中拥有该游戏的用户才可以评论");
        }

        validateReviewType(isPositive);
        ensureGameExists(gameId);

        GameReview review = gameReviewRepository.findByUserIdAndGameId(userId, gameId)
                .orElseGet(GameReview::new);

        review.setUserId(userId);
        review.setGameId(gameId);
        review.setIsPositive(isPositive);
        review.setContent(normalizeContent(content));
        review.setPlayHours(review.getPlayHours() == null ? BigDecimal.ZERO : review.getPlayHours());
        review.setStatus(1);

        GameReview savedReview = gameReviewRepository.save(review);
        refreshGameReviewStats(gameId);
        return savedReview;
    }

    public Page<GameReviewDto> getGameReviews(Long gameId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        Page<GameReview> reviewPage = gameReviewRepository.findByGameIdAndStatus(gameId, 1, pageable);
        List<GameReviewDto> content = reviewPage.getContent().stream()
                .map(this::toReviewDto)
                .toList();
        return new PageImpl<>(content, pageable, reviewPage.getTotalElements());
    }

    public GameReviewDto getMyReview(Long userId, Long gameId) {
        return gameReviewRepository.findByUserIdAndGameId(userId, gameId)
                .filter(review -> review.getStatus() != null && review.getStatus() == 1)
                .map(this::toReviewDto)
                .orElse(null);
    }

    public long getUserReviewCount(Long userId) {
        return gameReviewRepository.countByUserIdAndStatus(userId, 1);
    }

    public GameReviewSummaryDto getGameReviewSummary(Long gameId) {
        int positive = safeCount(gameReviewRepository.countPositiveByGameId(gameId));
        int negative = safeCount(gameReviewRepository.countNegativeByGameId(gameId));
        int total = positive + negative;

        return GameReviewSummaryDto.builder()
                .positiveReviews(positive)
                .negativeReviews(negative)
                .totalReviews(total)
                .positiveRate(total == 0 ? 0 : Math.round(positive * 100f / total))
                .build();
    }

    @Transactional
    public GameReview updateReview(Long reviewId, Long userId, Integer isPositive, String content) {
        validateReviewType(isPositive);
        GameReview review = gameReviewRepository.findByIdAndUserId(reviewId, userId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));

        review.setIsPositive(isPositive);
        review.setContent(normalizeContent(content));
        review.setStatus(1);

        GameReview savedReview = gameReviewRepository.save(review);
        refreshGameReviewStats(review.getGameId());
        return savedReview;
    }

    @Transactional
    public void deleteReview(Long reviewId, Long userId) {
        GameReview review = gameReviewRepository.findByIdAndUserId(reviewId, userId)
                .orElseThrow(() -> new RuntimeException("评论不存在"));

        Long gameId = review.getGameId();
        gameReviewRepository.delete(review);
        refreshGameReviewStats(gameId);
    }

    private void refreshGameReviewStats(Long gameId) {
        Game game = ensureGameExists(gameId);
        game.setPositiveReviews(safeCount(gameReviewRepository.countPositiveByGameId(gameId)));
        game.setNegativeReviews(safeCount(gameReviewRepository.countNegativeByGameId(gameId)));
        gameRepository.save(game);
    }

    private Game ensureGameExists(Long gameId) {
        return gameRepository.findById(gameId)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));
    }

    private GameReviewDto toReviewDto(GameReview review) {
        User user = userRepository.findById(review.getUserId()).orElse(null);
        return GameReviewDto.builder()
                .id(review.getId())
                .userId(review.getUserId())
                .username(user != null ? user.getUsername() : "匿名玩家")
                .userAvatar(user != null ? user.getAvatar() : null)
                .gameId(review.getGameId())
                .isPositive(review.getIsPositive())
                .content(review.getContent())
                .playHours(review.getPlayHours())
                .helpfulCount(review.getHelpfulCount())
                .createdAt(review.getCreatedAt())
                .updatedAt(review.getUpdatedAt())
                .build();
    }

    private void validateReviewType(Integer isPositive) {
        if (isPositive == null || (isPositive != 0 && isPositive != 1)) {
            throw new RuntimeException("评论类型必须是好评或差评");
        }
    }

    private String normalizeContent(String content) {
        if (content == null) {
            return null;
        }
        String trimmed = content.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private int safeCount(Integer count) {
        return count == null ? 0 : count;
    }
}
