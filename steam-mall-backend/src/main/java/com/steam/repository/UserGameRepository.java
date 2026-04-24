package com.steam.repository;

import com.steam.entity.UserGame;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserGameRepository extends JpaRepository<UserGame, Long> {
    
    Optional<UserGame> findByUserIdAndGameId(Long userId, Long gameId);
    
    Optional<UserGame> findByActivationCode(String activationCode);
    
    List<UserGame> findByUserIdAndIsActivated(Long userId, Integer isActivated);
    
    @Query("SELECT ug.gameId FROM UserGame ug WHERE ug.userId = :userId AND ug.isActivated = 1")
    List<Long> findGameIdsByUserId(@Param("userId") Long userId);
    
    boolean existsByUserIdAndGameId(Long userId, Long gameId);

    boolean existsByUserIdAndGameIdAndIsActivated(Long userId, Long gameId, Integer isActivated);
}
