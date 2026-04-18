package com.steam.service;

import com.steam.entity.Game;
import com.steam.entity.GameReview;
import com.steam.entity.UserGame;
import com.steam.repository.GameRepository;
import com.steam.repository.GameReviewRepository;
import com.steam.repository.UserGameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserGameService {

    private final UserGameRepository userGameRepository;
    private final GameRepository gameRepository;
    private final GameReviewRepository gameReviewRepository;

    public List<UserGame> getUserLibrary(Long userId) {
        return userGameRepository.findByUserIdAndIsActivated(userId, 1);
    }

    public List<Game> getUserGames(Long userId) {
        List<Long> gameIds = userGameRepository.findGameIdsByUserId(userId);
        return gameRepository.findAllById(gameIds);
    }

    public boolean ownsGame(Long userId, Long gameId) {
        return userGameRepository.existsByUserIdAndGameId(userId, gameId);
    }

    @Transactional
    public GameReview createReview(Long userId, Long gameId, Integer isPositive, String content) {
        if (!ownsGame(userId, gameId)) {
            throw new RuntimeException("只有拥有该游戏才能评价");
        }

        GameReview existingReview = gameReviewRepository.findByUserIdAndGameId(userId, gameId).orElse(null);
        if (existingReview != null) {
            existingReview.setIsPositive(isPositive);
            existingReview.setContent(content);
            return gameReviewRepository.save(existingReview);
        }

        GameReview review = new GameReview();
        review.setUserId(userId);
        review.setGameId(gameId);
        review.setIsPositive(isPositive);
        review.setContent(content);
        review.setPlayHours(java.math.BigDecimal.ZERO);
        review.setStatus(1);

        GameReview savedReview = gameReviewRepository.save(review);

        Game game = gameRepository.findById(gameId).orElse(null);
        if (game != null) {
            if (isPositive == 1) {
                game.setPositiveReviews(game.getPositiveReviews() + 1);
            } else {
                game.setNegativeReviews(game.getNegativeReviews() + 1);
            }
            gameRepository.save(game);
        }

        return savedReview;
    }

    public Page<GameReview> getGameReviews(Long gameId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return gameReviewRepository.findByGameIdAndStatus(gameId, 1, pageable);
    }

    @Transactional
    public void updateReview(Long reviewId, Integer isPositive, String content) {
        GameReview review = gameReviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("评价不存在"));
        review.setIsPositive(isPositive);
        review.setContent(content);
        gameReviewRepository.save(review);
    }

    @Transactional
    public void deleteReview(Long reviewId) {
        gameReviewRepository.deleteById(reviewId);
    }
}
