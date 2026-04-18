package com.steam.service;

import com.steam.entity.Game;
import com.steam.repository.GameRepository;
import com.steam.repository.GameReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class GameService {

    private final GameRepository gameRepository;
    private final GameReviewRepository gameReviewRepository;

    @Cacheable(value = "games", key = "#page + '-' + #size + '-' + #keyword")
    public Page<Game> searchGames(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return gameRepository.searchGames(keyword, pageable);
    }

    @Cacheable(value = "games", key = "'detail-' + #id")
    public Game getGameById(Long id) {
        Game game = gameRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));
        
        game.setViewCount(game.getViewCount() + 1);
        gameRepository.save(game);
        
        return game;
    }

    public Page<Game> getAllGames(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return gameRepository.findByStatus(1, pageable);
    }

    public Page<Game> getGamesByCategory(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return gameRepository.findByCategoryAndStatus(category, 1, pageable);
    }

    public Page<Game> getTopSalesGames(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return gameRepository.findTopGames(pageable);
    }

    public Page<Game> getTopRatedGames(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return gameRepository.findTopRatedGames(pageable);
    }

    public Page<Game> getGamesByDeveloper(String developer, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return gameRepository.findByDeveloperAndStatus(developer, 1, pageable);
    }

    public List<Game> getGamesByPublisher(String publisher) {
        return gameRepository.findByPublisher(publisher);
    }

    @Transactional
    @CacheEvict(value = "games", allEntries = true)
    public Game createGame(Game game) {
        return gameRepository.save(game);
    }

    @Transactional
    @CacheEvict(value = "games", allEntries = true)
    public Game updateGame(Long id, Game gameDetails) {
        Game game = gameRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));

        if (gameDetails.getName() != null) {
            game.setName(gameDetails.getName());
        }
        if (gameDetails.getDescription() != null) {
            game.setDescription(gameDetails.getDescription());
        }
        if (gameDetails.getShortDescription() != null) {
            game.setShortDescription(gameDetails.getShortDescription());
        }
        if (gameDetails.getCoverImage() != null) {
            game.setCoverImage(gameDetails.getCoverImage());
        }
        if (gameDetails.getBannerImage() != null) {
            game.setBannerImage(gameDetails.getBannerImage());
        }
        if (gameDetails.getPrice() != null) {
            game.setPrice(gameDetails.getPrice());
        }
        if (gameDetails.getDiscount() != null) {
            game.setDiscount(gameDetails.getDiscount());
        }
        if (gameDetails.getDeveloper() != null) {
            game.setDeveloper(gameDetails.getDeveloper());
        }
        if (gameDetails.getPublisher() != null) {
            game.setPublisher(gameDetails.getPublisher());
        }
        if (gameDetails.getReleaseDate() != null) {
            game.setReleaseDate(gameDetails.getReleaseDate());
        }
        if (gameDetails.getCategory() != null) {
            game.setCategory(gameDetails.getCategory());
        }
        if (gameDetails.getTags() != null) {
            game.setTags(gameDetails.getTags());
        }
        if (gameDetails.getVideoUrl() != null) {
            game.setVideoUrl(gameDetails.getVideoUrl());
        }
        if (gameDetails.getImages() != null) {
            game.setImages(gameDetails.getImages());
        }
        if (gameDetails.getSystemRequirements() != null) {
            game.setSystemRequirements(gameDetails.getSystemRequirements());
        }
        if (gameDetails.getStatus() != null) {
            game.setStatus(gameDetails.getStatus());
        }

        return gameRepository.save(game);
    }

    @Transactional
    @CacheEvict(value = "games", allEntries = true)
    public void deleteGame(Long id) {
        gameRepository.deleteById(id);
    }

    public Map<String, Object> getGameStatistics() {
        long totalGames = gameRepository.count();
        long totalSales = gameRepository.findAll().stream()
                .mapToLong(Game::getSalesCount).sum();
        
        return Map.of(
                "totalGames", totalGames,
                "totalSales", totalSales
        );
    }
}
