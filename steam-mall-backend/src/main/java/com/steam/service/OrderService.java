package com.steam.service;

import com.steam.dto.ShoppingCartCheckoutRequest;
import com.steam.entity.ActivationCode;
import com.steam.entity.Game;
import com.steam.entity.Order;
import com.steam.entity.ShoppingCart;
import com.steam.entity.UserGame;
import com.steam.repository.ActivationCodeRepository;
import com.steam.repository.GameRepository;
import com.steam.repository.OrderRepository;
import com.steam.repository.ShoppingCartRepository;
import com.steam.repository.UserGameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final GameRepository gameRepository;
    private final UserGameRepository userGameRepository;
    private final ActivationCodeRepository activationCodeRepository;
    private final ShoppingCartRepository shoppingCartRepository;
    private final HotSaleService hotSaleService;

    @Transactional
    public Order createOrder(Long userId, Long gameId) {
        Game game = validatePurchasableGame(userId, gameId);
        Order savedOrder = createPaidOrder(userId, game.getId(), game.getName(), resolveGamePrice(game));
        increaseSalesCount(game);
        shoppingCartRepository.deleteByUserIdAndGameId(userId, gameId);
        hotSaleService.refreshTop10();
        return savedOrder;
    }

    @Transactional
    public List<Order> createOrdersFromCart(Long userId, ShoppingCartCheckoutRequest request) {
        List<Long> cartItemIds = request == null ? null : request.getCartItemIds();
        if (cartItemIds == null || cartItemIds.isEmpty()) {
            throw new RuntimeException("请选择要购买的购物车商品");
        }

        List<Long> distinctIds = cartItemIds.stream().distinct().toList();
        List<ShoppingCart> cartItems = shoppingCartRepository.findByIdInAndUserId(distinctIds, userId);
        if (cartItems.size() != distinctIds.size()) {
            throw new RuntimeException("部分购物车商品不存在或无权操作");
        }

        List<Order> orders = new ArrayList<>();
        for (ShoppingCart cartItem : cartItems) {
            Game game = validatePurchasableGame(userId, cartItem.getGameId());
            Order order = createPaidOrder(userId, cartItem.getGameId(), cartItem.getGameName(), cartItem.getPrice());
            orders.add(order);
            increaseSalesCount(game);
        }

        shoppingCartRepository.deleteAll(cartItems);
        hotSaleService.refreshTop10();
        return orders;
    }

    @Transactional
    public Order payOrder(String orderNo, Long userId) {
        Order order = orderRepository.findByOrderNo(orderNo)
                .orElseThrow(() -> new RuntimeException("订单不存在"));

        if (!order.getUserId().equals(userId)) {
            throw new RuntimeException("无权操作该订单");
        }

        if (order.getPaymentStatus() != 0) {
            throw new RuntimeException("订单状态异常");
        }

        order.setPaymentStatus(1);
        order.setPaidAt(LocalDateTime.now());

        ActivationCode activationCode = generateActivationCode(
                order.getGameId(),
                order.getGameName(),
                order.getId()
        );
        order.setActivationCode(activationCode.getCode());

        Order savedOrder = orderRepository.save(order);

        Long paidGameId = Objects.requireNonNull(order.getGameId(), "订单游戏ID不能为空");
        Game game = gameRepository.findById(paidGameId).orElse(null);
        if (game != null) {
            increaseSalesCount(game);
            hotSaleService.refreshTop10();
        }

        return savedOrder;
    }

    public Page<Order> getUserOrders(Long userId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        return orderRepository.findByUserId(userId, pageable);
    }

    public Order getOrderById(String orderNo) {
        return orderRepository.findByOrderNo(orderNo)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
    }

    @Transactional
    public UserGame activateGame(String activationCode, Long userId) {
        ActivationCode ac = activationCodeRepository.findByCode(activationCode)
                .orElseThrow(() -> new RuntimeException("激活码无效"));

        if (ac.getStatus() != 0) {
            throw new RuntimeException("激活码已被使用或已过期");
        }

        if (ac.getExpireTime() != null && ac.getExpireTime().isBefore(LocalDateTime.now())) {
            ac.setStatus(2);
            activationCodeRepository.save(ac);
            throw new RuntimeException("激活码已过期");
        }

        if (userGameRepository.existsByUserIdAndGameId(userId, ac.getGameId())) {
            throw new RuntimeException("您已拥有该游戏");
        }

        UserGame userGame = new UserGame();
        userGame.setUserId(userId);
        userGame.setGameId(ac.getGameId());
        userGame.setActivationCode(activationCode);
        userGame.setIsActivated(1);
        userGame.setActivatedAt(LocalDateTime.now());
        userGameRepository.save(userGame);

        ac.setStatus(1);
        activationCodeRepository.save(ac);
        activationCodeRepository.delete(ac);

        return userGame;
    }

    private Game validatePurchasableGame(Long userId, Long gameId) {
        Long safeGameId = Objects.requireNonNull(gameId, "游戏ID不能为空");
        Game game = gameRepository.findById(safeGameId)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));

        if (game.getStatus() != 1) {
            throw new RuntimeException("游戏已下架");
        }

        if (userGameRepository.existsByUserIdAndGameId(userId, safeGameId)) {
            throw new RuntimeException("您已拥有该游戏");
        }

        return game;
    }

    private BigDecimal resolveGamePrice(Game game) {
        return game.getFinalPrice() != null ? game.getFinalPrice() : game.getPrice();
    }

    private void increaseSalesCount(Game game) {
        game.setSalesCount(game.getSalesCount() + 1);
        gameRepository.save(game);
    }

    private Order createPaidOrder(Long userId, Long gameId, String gameName, BigDecimal amount) {
        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setGameId(gameId);
        order.setGameName(gameName);
        order.setAmount(amount);
        order.setPaymentStatus(1);
        order.setPaidAt(LocalDateTime.now());

        Order savedOrder = orderRepository.save(order);
        ActivationCode activationCode = generateActivationCode(
                savedOrder.getGameId(),
                savedOrder.getGameName(),
                savedOrder.getId()
        );
        savedOrder.setActivationCode(activationCode.getCode());
        return orderRepository.save(savedOrder);
    }

    private ActivationCode generateActivationCode(Long gameId, String gameName, Long orderId) {
        String code;
        do {
            code = generateRandomCode();
        } while (activationCodeRepository.existsByCode(code));

        ActivationCode activationCode = new ActivationCode();
        activationCode.setCode(code);
        activationCode.setGameId(gameId);
        activationCode.setGameName(gameName);
        activationCode.setOrderId(orderId);
        activationCode.setStatus(0);
        activationCode.setExpireTime(LocalDateTime.now().plusYears(10));

        return activationCodeRepository.save(activationCode);
    }

    private String generateRandomCode() {
        String charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder code = new StringBuilder();
        java.security.SecureRandom random = new java.security.SecureRandom();

        for (int i = 0; i < 16; i++) {
            if (i > 0 && i % 4 == 0) {
                code.append("-");
            }
            code.append(charset.charAt(random.nextInt(charset.length())));
        }

        return code.toString();
    }

    private String generateOrderNo() {
        return "ORD" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
