package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.Game;
import com.steam.service.GameService;
import com.steam.service.OssService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/games")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "*")
public class AdminGameController {

    private final GameService gameService;
    private final OssService ossService;

    @GetMapping
    public ApiResponse<Object> getAllGames(
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

    @PostMapping
    public ApiResponse<Game> createGame(@RequestBody Game game) {
        try {
            Game savedGame = gameService.createGame(game);
            return ApiResponse.success("游戏创建成功", savedGame);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<Game> updateGame(@PathVariable Long id, @RequestBody Game game) {
        try {
            Game updatedGame = gameService.updateGame(id, game);
            return ApiResponse.success("游戏更新成功", updatedGame);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteGame(@PathVariable Long id) {
        try {
            gameService.deleteGame(id);
            return ApiResponse.success("游戏已删除", null);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/upload/image")
    public ApiResponse<Map<String, String>> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            String url = ossService.uploadImage(file);
            Map<String, String> result = new HashMap<>();
            result.put("url", url);
            return ApiResponse.success(result);
        } catch (IOException e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/upload/video")
    public ApiResponse<Map<String, String>> uploadVideo(@RequestParam("file") MultipartFile file) {
        try {
            String url = ossService.uploadVideo(file);
            Map<String, String> result = new HashMap<>();
            result.put("url", url);
            return ApiResponse.success(result);
        } catch (IOException e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
