package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.Carousel;
import com.steam.repository.CarouselRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/carousels")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CarouselController {

    private final CarouselRepository carouselRepository;

    @GetMapping
    public ApiResponse<List<Carousel>> getAllCarousels() {
        List<Carousel> carousels = carouselRepository.findByStatusOrderBySortOrder(1);
        return ApiResponse.success(carousels);
    }
}
