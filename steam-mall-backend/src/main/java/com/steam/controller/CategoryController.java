package com.steam.controller;

import com.steam.dto.ApiResponse;
import com.steam.entity.GameCategory;
import com.steam.repository.GameCategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categories")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CategoryController {

    private final GameCategoryRepository gameCategoryRepository;

    @GetMapping
    public ApiResponse<List<GameCategory>> getAllCategories() {
        List<GameCategory> categories = gameCategoryRepository.findByStatusOrderBySortOrder(1);
        return ApiResponse.success(categories);
    }
}
