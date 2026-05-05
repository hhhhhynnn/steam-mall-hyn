package com.steam.dto;

import lombok.Data;

import java.util.List;

@Data
public class ShoppingCartCheckoutRequest {

    private List<Long> cartItemIds;
}
