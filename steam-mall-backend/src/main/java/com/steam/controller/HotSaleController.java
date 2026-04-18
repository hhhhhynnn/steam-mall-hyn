package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.HotSale;
import com.steam.service.HotSaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hot-sale")
@RequiredArgsConstructor
public class HotSaleController {

    private final HotSaleService hotSaleService;

    /**
     * 获取热销榜前 10 名
     */
    @GetMapping
    public ApiResponse<List<HotSale>> getHotSaleList(
            @RequestParam(defaultValue = "ALL") String periodType) {
        List<HotSale> hotSales = hotSaleService.getTop10(periodType);
        return ApiResponse.success(hotSales);
    }
}