package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.dto.FeaturedGameCarouselDto;
import com.steam.entity.Carousel;
import com.steam.service.CarouselService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin/carousels")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "*")
public class AdminCarouselController {

    private final CarouselService carouselService;

    @GetMapping
    public ApiResponse<List<FeaturedGameCarouselDto>> getAllFeaturedCarousels() {
        return ApiResponse.success(carouselService.getAdminCarousels());
    }

    @PostMapping
    public ApiResponse<FeaturedGameCarouselDto> createFeaturedCarousel(@RequestBody Carousel carousel) {
        try {
            return ApiResponse.success("精选推荐创建成功", carouselService.createFeaturedGameCarousel(carousel));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<FeaturedGameCarouselDto> updateFeaturedCarousel(
            @PathVariable Long id,
            @RequestBody Carousel carousel) {
        try {
            return ApiResponse.success("精选推荐更新成功", carouselService.updateFeaturedGameCarousel(id, carousel));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteFeaturedCarousel(@PathVariable Long id) {
        try {
            carouselService.deleteCarousel(id);
            return ApiResponse.success("精选推荐已删除", null);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
