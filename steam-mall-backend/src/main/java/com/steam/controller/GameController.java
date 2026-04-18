package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.Game;
import com.steam.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/games")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class GameController {

    private final GameService gameService;

    @GetMapping
    public ApiResponse<Page<Game>> getAllGames(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.getAllGames(page, size));
    }

    @GetMapping("/{id}")
    public ApiResponse<Game> getGameById(@PathVariable Long id) {
        try {
            return ApiResponse.success(gameService.getGameById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/search")
    public ApiResponse<Page<Game>> searchGames(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.searchGames(keyword, page, size));
    }

    @GetMapping("/category/{category}")
    public ApiResponse<Page<Game>> getGamesByCategory(
            @PathVariable String category,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.getGamesByCategory(category, page, size));
    }

    @GetMapping("/top/sales")
    public ApiResponse<Page<Game>> getTopSalesGames(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.getTopSalesGames(page, size));
    }

    @GetMapping("/top/rated")
    public ApiResponse<Page<Game>> getTopRatedGames(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.getTopRatedGames(page, size));
    }

    @GetMapping("/developer/{developer}")
    public ApiResponse<Page<Game>> getGamesByDeveloper(
            @PathVariable String developer,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ApiResponse.success(gameService.getGamesByDeveloper(developer, page, size));
    }

    @GetMapping("/publisher/{publisher}")
    public ApiResponse<List<Game>> getGamesByPublisher(@PathVariable String publisher) {
        return ApiResponse.success(gameService.getGamesByPublisher(publisher));
    }
}
