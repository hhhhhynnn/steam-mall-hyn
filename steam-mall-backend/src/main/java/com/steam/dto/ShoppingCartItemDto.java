package com.steam.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
public class ShoppingCartItemDto {

    private Long id;
    private Long gameId;
    private String gameName;
    private BigDecimal price;
    private String coverImage;
    private String bannerImage;
    private BigDecimal currentPrice;
    private BigDecimal originalPrice;
    private BigDecimal discount;
    private String developer;
    private String category;
    private Integer status;
    private Boolean owned;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
