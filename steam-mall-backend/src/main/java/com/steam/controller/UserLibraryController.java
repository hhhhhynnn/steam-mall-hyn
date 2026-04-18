package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.Game;
import com.steam.entity.UserGame;
import com.steam.service.AuthenticatedUserService;
import com.steam.service.UserGameService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user/library")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserLibraryController {

    private final UserGameService userGameService;
    private final AuthenticatedUserService authenticatedUserService;

    @GetMapping
    public ApiResponse<List<UserGame>> getLibrary(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            List<UserGame> library = userGameService.getUserLibrary(userId);
            return ApiResponse.success(library);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/games")
    public ApiResponse<List<Game>> getUserGames(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            List<Game> games = userGameService.getUserGames(userId);
            return ApiResponse.success(games);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/owns/{gameId}")
    public ApiResponse<Boolean> checkOwnership(
            @PathVariable Long gameId,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            boolean owns = userGameService.ownsGame(userId, gameId);
            return ApiResponse.success(owns);
        } catch (Exception e) {
            return ApiResponse.success(false);
        }
    }
}
