package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.dto.FeaturedGameCarouselDto;
import com.steam.entity.Carousel;
import com.steam.service.CarouselService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/carousels")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CarouselController {

    private final CarouselService carouselService;

    @GetMapping
    public ApiResponse<List<Carousel>> getAllCarousels() {
        return ApiResponse.success(carouselService.getAllCarousels());
    }

    @GetMapping("/featured")
    public ApiResponse<List<FeaturedGameCarouselDto>> getFeaturedGames() {
        return ApiResponse.success(carouselService.getFeaturedGameCarousels());
    }
}
