package com.steam.dto;

import lombok.Data;
import lombok.experimental.Accessors;

import java.math.BigDecimal;
import java.util.List;

@Data
@Accessors(chain = true)
public class ShoppingCartSummaryDto {

    private List<ShoppingCartItemDto> items;
    private Long totalCount;
    private BigDecimal totalAmount;
}
