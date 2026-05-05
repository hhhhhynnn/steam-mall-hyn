package com.steam.service;

import com.steam.dto.FeaturedGameCarouselDto;
import com.steam.entity.Carousel;
import com.steam.entity.Game;
import com.steam.repository.CarouselRepository;
import com.steam.repository.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Locale;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class CarouselService {

    private static final String TARGET_TYPE_GAME = "GAME";

    private final CarouselRepository carouselRepository;
    private final GameRepository gameRepository;

    public List<Carousel> getAllCarousels() {
        return carouselRepository.findByStatusOrderBySortOrder(1);
    }

    public List<FeaturedGameCarouselDto> getFeaturedGameCarousels() {
        return carouselRepository.findByStatusOrderBySortOrder(1).stream()
                .filter(this::isGameCarousel)
                .map(this::toFeaturedDto)
                .filter(Objects::nonNull)
                .toList();
    }

    public List<FeaturedGameCarouselDto> getAdminCarousels() {
        return carouselRepository.findAllByOrderBySortOrderAscIdAsc().stream()
                .filter(this::isGameCarousel)
                .map(this::toFeaturedDto)
                .filter(Objects::nonNull)
                .toList();
    }

    @Transactional
    public FeaturedGameCarouselDto createFeaturedGameCarousel(Carousel carousel) {
        Game game = loadGame(carousel.getTargetId());
        Carousel prepared = prepareCarousel(carousel, game, false);
        return toFeaturedDto(carouselRepository.save(prepared));
    }

    @Transactional
    public FeaturedGameCarouselDto updateFeaturedGameCarousel(Long id, Carousel details) {
        Carousel existing = carouselRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("精选推荐不存在"));

        Long targetGameId = details.getTargetId() != null ? details.getTargetId() : existing.getTargetId();
        Game game = loadGame(targetGameId);
        Carousel prepared = prepareCarousel(existing, details, game);
        return toFeaturedDto(carouselRepository.save(prepared));
    }

    @Transactional
    public void deleteCarousel(Long id) {
        if (!carouselRepository.existsById(id)) {
            throw new RuntimeException("精选推荐不存在");
        }
        carouselRepository.deleteById(id);
    }

    private boolean isGameCarousel(Carousel carousel) {
        return carousel.getTargetId() != null
                && TARGET_TYPE_GAME.equalsIgnoreCase(normalizeTargetType(carousel.getTargetType()));
    }

    private FeaturedGameCarouselDto toFeaturedDto(Carousel carousel) {
        if (carousel.getTargetId() == null) {
            return null;
        }

        return gameRepository.findById(carousel.getTargetId())
                .filter(game -> game.getStatus() != null && game.getStatus() == 1)
                .map(game -> FeaturedGameCarouselDto.builder()
                        .carouselId(carousel.getId())
                        .gameId(game.getId())
                        .title(StringUtils.hasText(carousel.getTitle()) ? carousel.getTitle() : game.getName())
                        .subtitle(game.getDeveloper())
                        .imageUrl(resolveImage(game, carousel))
                        .coverImage(game.getCoverImage())
                        .gameName(game.getName())
                        .shortDescription(game.getShortDescription())
                        .category(game.getCategory())
                        .price(game.getPrice())
                        .finalPrice(game.getFinalPrice())
                        .discount(game.getDiscount())
                        .status(carousel.getStatus())
                        .sortOrder(carousel.getSortOrder())
                        .build())
                .orElse(null);
    }

    private Carousel prepareCarousel(Carousel incoming, Game game, boolean forceStatusOne) {
        Carousel carousel = new Carousel();
        carousel.setTitle(incoming.getTitle());
        carousel.setTargetId(game.getId());
        carousel.setTargetType(TARGET_TYPE_GAME);
        carousel.setImageUrl(resolveImage(game, incoming));
        carousel.setSortOrder(incoming.getSortOrder() == null ? 0 : incoming.getSortOrder());
        carousel.setStatus(forceStatusOne ? 1 : (incoming.getStatus() == null ? 1 : incoming.getStatus()));
        carousel.setTargetUrl("/game/" + game.getId());
        return carousel;
    }

    private Carousel prepareCarousel(Carousel existing, Carousel details, Game game) {
        existing.setTitle(details.getTitle());
        existing.setTargetId(game.getId());
        existing.setTargetType(TARGET_TYPE_GAME);
        existing.setImageUrl(resolveImage(game, details));
        existing.setSortOrder(details.getSortOrder() == null ? existing.getSortOrder() : details.getSortOrder());
        existing.setStatus(details.getStatus() == null ? existing.getStatus() : details.getStatus());
        existing.setTargetUrl("/game/" + game.getId());
        return existing;
    }

    private Game loadGame(Long gameId) {
        if (gameId == null) {
            throw new RuntimeException("请选择要投放的游戏");
        }

        return gameRepository.findById(gameId)
                .filter(game -> game.getStatus() != null && game.getStatus() == 1)
                .orElseThrow(() -> new RuntimeException("所选游戏不存在或已下架"));
    }

    private String resolveImage(Game game, Carousel carousel) {
        if (StringUtils.hasText(game.getBannerImage())) {
            return game.getBannerImage();
        }
        if (StringUtils.hasText(game.getCoverImage())) {
            return game.getCoverImage();
        }
        return carousel.getImageUrl();
    }

    private String normalizeTargetType(String targetType) {
        return targetType == null ? "" : targetType.trim().toUpperCase(Locale.ROOT);
    }
}
