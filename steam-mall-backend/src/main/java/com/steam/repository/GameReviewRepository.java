package com.steam.repository;

import com.steam.entity.GameReview;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GameReviewRepository extends JpaRepository<GameReview, Long> {
    
    Page<GameReview> findByGameIdAndStatus(Long gameId, Integer status, Pageable pageable);
    
    Optional<GameReview> findByUserIdAndGameId(Long userId, Long gameId);

    Optional<GameReview> findByIdAndUserId(Long id, Long userId);
    
    List<GameReview> findByUserId(Long userId);
    
    @Query("SELECT COUNT(r) FROM GameReview r WHERE r.gameId = :gameId AND r.status = 1 AND r.isPositive = 1")
    Integer countPositiveByGameId(@Param("gameId") Long gameId);
    
    @Query("SELECT COUNT(r) FROM GameReview r WHERE r.gameId = :gameId AND r.status = 1 AND r.isPositive = 0")
    Integer countNegativeByGameId(@Param("gameId") Long gameId);
}
