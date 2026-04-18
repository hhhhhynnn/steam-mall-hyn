package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.GameReview;
import com.steam.service.AuthenticatedUserService;
import com.steam.service.UserGameService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/reviews")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ReviewController {

    private final UserGameService userGameService;
    private final AuthenticatedUserService authenticatedUserService;

    @GetMapping("/game/{gameId}")
    public ApiResponse<Object> getGameReviews(
            @PathVariable Long gameId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            return ApiResponse.success(userGameService.getGameReviews(gameId, page, size));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<GameReview> createReview(
            @RequestParam Long gameId,
            @RequestParam Integer isPositive,
            @RequestParam(required = false) String content,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            GameReview review = userGameService.createReview(userId, gameId, isPositive, content);
            return ApiResponse.success("评价成功", review);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{reviewId}")
    public ApiResponse<GameReview> updateReview(
            @PathVariable Long reviewId,
            @RequestParam Integer isPositive,
            @RequestParam(required = false) String content,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            userGameService.updateReview(reviewId, isPositive, content);
            return ApiResponse.success("评价已更新", null);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{reviewId}")
    public ApiResponse<Void> deleteReview(
            @PathVariable Long reviewId,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            userGameService.deleteReview(reviewId);
            return ApiResponse.success("评价已删除", null);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
