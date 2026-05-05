package com.steam.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class FeaturedGameCarouselDto {

    private Long carouselId;
    private Long gameId;
    private String title;
    private String subtitle;
    private String imageUrl;
    private String coverImage;
    private String gameName;
    private String shortDescription;
    private String category;
    private BigDecimal price;
    private BigDecimal finalPrice;
    private BigDecimal discount;
    private Integer status;
    private Integer sortOrder;
}
