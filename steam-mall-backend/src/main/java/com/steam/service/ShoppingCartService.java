package com.steam.service;

import com.steam.dto.ShoppingCartItemDto;
import com.steam.dto.ShoppingCartSummaryDto;
import com.steam.entity.Game;
import com.steam.entity.ShoppingCart;
import com.steam.repository.GameRepository;
import com.steam.repository.ShoppingCartRepository;
import com.steam.repository.UserGameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShoppingCartService {

    private final ShoppingCartRepository shoppingCartRepository;
    private final GameRepository gameRepository;
    private final UserGameRepository userGameRepository;

    @Transactional
    public ShoppingCart addToCart(Long userId, Long gameId) {
        Long safeGameId = Objects.requireNonNull(gameId, "游戏ID不能为空");
        Game game = gameRepository.findById(safeGameId)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));

        if (game.getStatus() != 1) {
            throw new RuntimeException("游戏已下架");
        }

        if (userGameRepository.existsByUserIdAndGameId(userId, safeGameId)) {
            throw new RuntimeException("您已拥有该游戏");
        }

        if (shoppingCartRepository.existsByUserIdAndGameId(userId, safeGameId)) {
            throw new RuntimeException("该游戏已在购物车中");
        }

        ShoppingCart shoppingCart = new ShoppingCart()
                .setUserId(userId)
                .setGameId(safeGameId)
                .setGameName(game.getName())
                .setPrice(resolveGamePrice(game));

        return shoppingCartRepository.save(shoppingCart);
    }

    public ShoppingCartSummaryDto getCart(Long userId) {
        List<ShoppingCart> cartItems = shoppingCartRepository.findByUserIdOrderByCreatedAtDesc(userId);
        if (cartItems.isEmpty()) {
            return new ShoppingCartSummaryDto()
                    .setItems(Collections.emptyList())
                    .setTotalCount(0L)
                    .setTotalAmount(BigDecimal.ZERO);
        }

        Map<Long, Game> gameMap = gameRepository.findAllById(
                        cartItems.stream().map(ShoppingCart::getGameId).toList()
                ).stream()
                .collect(Collectors.toMap(Game::getId, Function.identity()));

        List<ShoppingCartItemDto> items = cartItems.stream()
                .map(item -> toDto(item, gameMap.get(item.getGameId()), userId))
                .toList();

        BigDecimal totalAmount = items.stream()
                .map(ShoppingCartItemDto::getPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return new ShoppingCartSummaryDto()
                .setItems(items)
                .setTotalCount((long) items.size())
                .setTotalAmount(totalAmount);
    }

    public long getCartCount(Long userId) {
        return shoppingCartRepository.countByUserId(userId);
    }

    @Transactional
    public void removeFromCart(Long userId, Long cartItemId) {
        ShoppingCart item = shoppingCartRepository.findByIdAndUserId(cartItemId, userId)
                .orElseThrow(() -> new RuntimeException("购物车商品不存在"));
        shoppingCartRepository.delete(item);
    }

    private ShoppingCartItemDto toDto(ShoppingCart cartItem, Game game, Long userId) {
        BigDecimal currentPrice = game == null ? cartItem.getPrice() : resolveGamePrice(game);
        BigDecimal originalPrice = game == null ? cartItem.getPrice() : game.getPrice();
        boolean owned = userGameRepository.existsByUserIdAndGameId(userId, cartItem.getGameId());

        return new ShoppingCartItemDto()
                .setId(cartItem.getId())
                .setGameId(cartItem.getGameId())
                .setGameName(cartItem.getGameName())
                .setPrice(cartItem.getPrice())
                .setCoverImage(game == null ? null : game.getCoverImage())
                .setBannerImage(game == null ? null : game.getBannerImage())
                .setCurrentPrice(currentPrice)
                .setOriginalPrice(originalPrice)
                .setDiscount(game == null ? BigDecimal.ZERO : game.getDiscount())
                .setDeveloper(game == null ? null : game.getDeveloper())
                .setCategory(game == null ? null : game.getCategory())
                .setStatus(game == null ? 0 : game.getStatus())
                .setOwned(owned)
                .setCreatedAt(cartItem.getCreatedAt())
                .setUpdatedAt(cartItem.getUpdatedAt());
    }

    private BigDecimal resolveGamePrice(Game game) {
        return game.getFinalPrice() != null ? game.getFinalPrice() : game.getPrice();
    }
}
