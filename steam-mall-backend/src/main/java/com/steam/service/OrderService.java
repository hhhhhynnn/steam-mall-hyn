package com.steam.service;

import com.steam.entity.ActivationCode;
import com.steam.entity.Game;
import com.steam.entity.Order;
import com.steam.entity.UserGame;
import com.steam.repository.ActivationCodeRepository;
import com.steam.repository.GameRepository;
import com.steam.repository.OrderRepository;
import com.steam.repository.UserGameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final GameRepository gameRepository;
    private final UserGameRepository userGameRepository;
    private final ActivationCodeRepository activationCodeRepository;

    @Transactional
    public Order createOrder(Long userId, Long gameId) {
        Long safeGameId = Objects.requireNonNull(gameId, "游戏ID不能为空");
        Game game = gameRepository.findById(safeGameId)
                .orElseThrow(() -> new RuntimeException("游戏不存在"));

        if (game.getStatus() != 1) {
            throw new RuntimeException("游戏已下架");
        }

        if (userGameRepository.existsByUserIdAndGameId(userId, gameId)) {
            throw new RuntimeException("您已拥有该游戏");
        }

        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setGameId(gameId);
        order.setGameName(game.getName());
        order.setAmount(game.getFinalPrice() != null ? game.getFinalPrice() : game.getPrice());
        order.setPaymentStatus(1);
        order.setPaidAt(LocalDateTime.now());

        Order savedOrder = orderRepository.save(order);

        ActivationCode activationCode = generateActivationCode(
                savedOrder.getGameId(),
                savedOrder.getGameName(),
                savedOrder.getId()
        );
        savedOrder.setActivationCode(activationCode.getCode());

        // 点击购买即视为已完成购买，直接更新销量
        game.setSalesCount(game.getSalesCount() + 1);
        gameRepository.save(game);

        return orderRepository.save(savedOrder);
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

        // 生成激活码并回填到订单
        ActivationCode activationCode = generateActivationCode(
            order.getGameId(),
            order.getGameName(),
            order.getId()
        );
        order.setActivationCode(activationCode.getCode());

        Order savedOrder = orderRepository.save(order);

        // 更新游戏销量
        Long paidGameId = Objects.requireNonNull(order.getGameId(), "订单游戏ID不能为空");
        Game game = gameRepository.findById(paidGameId).orElse(null);
        if (game != null) {
            game.setSalesCount(game.getSalesCount() + 1);
            gameRepository.save(game);
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
        // 从 activation_code 表查询激活码
        ActivationCode ac = activationCodeRepository.findByCode(activationCode)
                .orElseThrow(() -> new RuntimeException("激活码无效"));

        // 检查激活码状态
        if (ac.getStatus() != 0) {
            throw new RuntimeException("激活码已被使用或已过期");
        }

        // 检查是否过期
        if (ac.getExpireTime() != null && ac.getExpireTime().isBefore(LocalDateTime.now())) {
            ac.setStatus(2);  // 设置为已过期
            activationCodeRepository.save(ac);
            throw new RuntimeException("激活码已过期");
        }

        // 检查用户是否已拥有该游戏
        if (userGameRepository.existsByUserIdAndGameId(userId, ac.getGameId())) {
            throw new RuntimeException("您已拥有该游戏");
        }

        // 添加到用户游戏库
        UserGame userGame = new UserGame();
        userGame.setUserId(userId);
        userGame.setGameId(ac.getGameId());
        userGame.setActivationCode(activationCode);
        userGame.setIsActivated(1);
        userGame.setActivatedAt(LocalDateTime.now());
        userGameRepository.save(userGame);

        // 更新激活码状态为已使用
        ac.setStatus(1);
        ac.setUserId(userId);
        ac.setActivatedAt(LocalDateTime.now());
        activationCodeRepository.save(ac);

        // 删除已使用的激活码，防止二次使用
        activationCodeRepository.delete(ac);

        return userGame;
    }

    /**
     * 生成激活码并存储到数据库
     */
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
        activationCode.setStatus(0);  // 未使用
        activationCode.setExpireTime(LocalDateTime.now().plusYears(10));  // 10 年有效期

        return activationCodeRepository.save(activationCode);
    }

    /**
     * 生成随机激活码（格式：XXXX-XXXX-XXXX-XXXX）
     */
    private String generateRandomCode() {
        String charset = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";  // 排除易混淆字符 I、O、1、0
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

    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        return "ORD" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
