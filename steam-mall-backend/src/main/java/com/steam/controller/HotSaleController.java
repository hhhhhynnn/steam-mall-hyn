package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.HotSale;
import com.steam.service.HotSaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/hot-sale")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class HotSaleController {

    private final HotSaleService hotSaleService;

    @GetMapping
    public ApiResponse<List<HotSale>> getHotSaleList() {
        return ApiResponse.success(hotSaleService.getTop10());
    }
}
