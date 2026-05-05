package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.dto.ShoppingCartSummaryDto;
import com.steam.entity.ShoppingCart;
import com.steam.service.AuthenticatedUserService;
import com.steam.service.ShoppingCartService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/cart")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ShoppingCartController {

    private final ShoppingCartService shoppingCartService;
    private final AuthenticatedUserService authenticatedUserService;

    @GetMapping
    public ApiResponse<ShoppingCartSummaryDto> getCart(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            return ApiResponse.success(shoppingCartService.getCart(userId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/count")
    public ApiResponse<Map<String, Long>> getCartCount(@AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            return ApiResponse.success(Map.of("count", shoppingCartService.getCartCount(userId)));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{gameId}")
    public ApiResponse<ShoppingCart> addToCart(
            @PathVariable Long gameId,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            return ApiResponse.success("已加入购物车", shoppingCartService.addToCart(userId, gameId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{cartItemId}")
    public ApiResponse<Void> removeFromCart(
            @PathVariable Long cartItemId,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            shoppingCartService.removeFromCart(userId, cartItemId);
            return ApiResponse.success("已从购物车移除", null);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
