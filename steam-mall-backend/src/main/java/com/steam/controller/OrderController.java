package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.Order;
import com.steam.entity.UserGame;
import com.steam.service.AuthenticatedUserService;
import com.steam.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class OrderController {

    private final OrderService orderService;
    private final AuthenticatedUserService authenticatedUserService;

    @PostMapping("/{gameId}")
    public ApiResponse<Order> createOrder(
            @PathVariable Long gameId,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            Order order = orderService.createOrder(userId, gameId);
            return ApiResponse.success("购买成功，已生成激活码", order);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{orderNo}/pay")
    public ApiResponse<Order> payOrder(
            @PathVariable String orderNo,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            Order order = orderService.payOrder(orderNo, userId);
            return ApiResponse.success("支付成功", order);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping
    public ApiResponse<Object> getUserOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            return ApiResponse.success(orderService.getUserOrders(userId, page, size));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{orderNo}")
    public ApiResponse<Order> getOrder(@PathVariable String orderNo) {
        try {
            return ApiResponse.success(orderService.getOrderById(orderNo));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/activate")
    public ApiResponse<UserGame> activateGame(
            @RequestParam String activationCode,
            @AuthenticationPrincipal UserDetails userDetails) {
        try {
            Long userId = authenticatedUserService.getCurrentUserId(userDetails);
            UserGame userGame = orderService.activateGame(activationCode, userId);
            return ApiResponse.success("激活成功", userGame);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
