package com.steam.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
public class GameReviewDto {

    private Long id;
    private Long userId;
    private String username;
    private String userAvatar;
    private Long gameId;
    private Integer isPositive;
    private String content;
    private BigDecimal playHours;
    private Integer helpfulCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
