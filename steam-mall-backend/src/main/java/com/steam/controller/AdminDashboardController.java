package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.service.AdminDashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/admin/dashboard")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "*")
public class AdminDashboardController {

    private final AdminDashboardService adminDashboardService;

    @GetMapping("/statistics")
    public ApiResponse<Map<String, Object>> getStatistics() {
        return ApiResponse.success(adminDashboardService.getStatistics());
    }
}
