package com.steam.service;

import com.steam.entity.Game;
import com.steam.entity.Order;
import com.steam.repository.GameRepository;
import com.steam.repository.OrderRepository;
import com.steam.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminDashboardService {

    private final GameRepository gameRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;

    public Map<String, Object> getStatistics() {
        Map<String, Object> result = new HashMap<>();

        long totalGames = gameRepository.count();
        long totalUsers = userRepository.count();

        List<Order> paidOrders = orderRepository.findByPaymentStatus(1);
        long totalSales = paidOrders.size();

        BigDecimal totalRevenue = paidOrders.stream()
                .map(Order::getAmount)
                .filter(amount -> amount != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        result.put("totalGames", totalGames);
        result.put("totalUsers", totalUsers);
        result.put("totalSales", totalSales);
        result.put("totalRevenue", totalRevenue);
        result.put("categoryDistribution", buildCategoryDistribution());
        result.put("weeklySalesAmount", buildWeeklySalesAmount());
        return result;
    }

    private List<Map<String, Object>> buildCategoryDistribution() {
        List<Game> games = gameRepository.findAll();
        Map<String, Integer> categoryCount = new LinkedHashMap<>();

        for (Game game : games) {
            if (game.getCategory() == null || game.getCategory().isBlank()) {
                continue;
            }
            String[] categories = game.getCategory().split(",");
            for (String category : categories) {
                String normalized = category.trim();
                if (normalized.isEmpty()) {
                    continue;
                }
                categoryCount.put(normalized, categoryCount.getOrDefault(normalized, 0) + 1);
            }
        }

        List<Map<String, Object>> data = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : categoryCount.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", entry.getKey());
            item.put("value", entry.getValue());
            data.add(item);
        }
        return data;
    }

    private List<Map<String, Object>> buildWeeklySalesAmount() {
        LocalDate today = LocalDate.now();
        LocalDate monday = today.with(DayOfWeek.MONDAY);
        LocalDate sunday = monday.plusDays(6);

        LocalDateTime start = monday.atStartOfDay();
        LocalDateTime end = sunday.plusDays(1).atStartOfDay().minusNanos(1);
        List<Order> weeklyOrders = orderRepository.findByPaymentStatusAndPaidAtBetween(1, start, end);

        Map<LocalDate, BigDecimal> dailyAmount = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) {
            dailyAmount.put(monday.plusDays(i), BigDecimal.ZERO);
        }

        for (Order order : weeklyOrders) {
            if (order.getPaidAt() == null || order.getAmount() == null) {
                continue;
            }
            LocalDate day = order.getPaidAt().toLocalDate();
            if (dailyAmount.containsKey(day)) {
                dailyAmount.put(day, dailyAmount.get(day).add(order.getAmount()));
            }
        }

        String[] labels = {"周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        List<Map<String, Object>> data = new ArrayList<>();
        int index = 0;
        for (Map.Entry<LocalDate, BigDecimal> entry : dailyAmount.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("day", labels[index++]);
            item.put("amount", entry.getValue());
            data.add(item);
        }
        return data;
    }
}
