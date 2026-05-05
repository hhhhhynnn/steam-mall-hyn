package com.steam.repository;

import com.steam.entity.ShoppingCart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ShoppingCartRepository extends JpaRepository<ShoppingCart, Long> {

    List<ShoppingCart> findByUserIdOrderByCreatedAtDesc(Long userId);

    Optional<ShoppingCart> findByIdAndUserId(Long id, Long userId);

    List<ShoppingCart> findByIdInAndUserId(List<Long> ids, Long userId);

    boolean existsByUserIdAndGameId(Long userId, Long gameId);

    long countByUserId(Long userId);

    void deleteByUserIdAndGameId(Long userId, Long gameId);
}
