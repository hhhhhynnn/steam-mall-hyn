package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.ActivationCode;
import com.steam.service.ActivationCodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/activation-code")
@RequiredArgsConstructor
public class ActivationCodeController {

    private final ActivationCodeService activationCodeService;

    /**
     * 验证激活码
     */
    @GetMapping("/validate")
    public ApiResponse<Map<String, Object>> validateCode(@RequestParam String code) {
        boolean isValid = activationCodeService.validateCode(code);
        return ApiResponse.success(Map.of("valid", isValid));
    }

    /**
     * 激活激活码
     */
    @PostMapping("/activate")
    public ApiResponse<ActivationCode> activateCode(
            @RequestParam String code,
            @AuthenticationPrincipal User user) {

        if (user == null) {
            throw new RuntimeException("请先登录");
        }

        // 从用户名获取用户 ID（需要实现用户服务）
        Long userId = getUserIdByUsername(user.getUsername());

        ActivationCode activatedCode = activationCodeService.activateCode(code, userId);
        return ApiResponse.success(activatedCode);
    }

    private Long getUserIdByUsername(String username) {
        // TODO: 实现从用户名获取用户 ID 的逻辑
        // 这里需要注入 UserRepository
        return 1L;  // 临时返回
    }
}