package com.steam.repository;

import com.steam.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    Optional<Order> findByOrderNo(String orderNo);
    
    Page<Order> findByUserId(Long userId, Pageable pageable);
    
    boolean existsByOrderNo(String orderNo);

    List<Order> findByPaymentStatus(Integer paymentStatus);

    List<Order> findByPaymentStatusAndPaidAtBetween(Integer paymentStatus, LocalDateTime start, LocalDateTime end);
}
