package com.steam.repository;

import com.steam.entity.Game;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GameRepository extends JpaRepository<Game, Long> {
    
    Page<Game> findByStatus(Integer status, Pageable pageable);
    
    @Query("SELECT g FROM Game g WHERE g.status = :status AND CONCAT(',', g.category, ',') LIKE CONCAT('%,', :category, ',%')")
    Page<Game> findByCategoryAndStatus(@Param("category") String category, @Param("status") Integer status, Pageable pageable);
    
    @Query("SELECT g FROM Game g WHERE g.status = 1 AND " +
           "(g.name LIKE %:keyword% OR g.description LIKE %:keyword% OR g.tags LIKE %:keyword%)")
    Page<Game> searchGames(@Param("keyword") String keyword, Pageable pageable);
    
    @Query("SELECT g FROM Game g WHERE g.status = 1 ORDER BY g.salesCount DESC")
    Page<Game> findTopGames(Pageable pageable);
    
    @Query("""
            SELECT g FROM Game g
            WHERE g.status = 1 AND (g.positiveReviews + g.negativeReviews) > 0
            ORDER BY
            (1.0 * g.positiveReviews / (g.positiveReviews + g.negativeReviews)) DESC,
            (g.positiveReviews + g.negativeReviews) DESC,
            g.positiveReviews DESC
            """)
    Page<Game> findTopRatedGames(Pageable pageable);
    
    @Query("SELECT g FROM Game g WHERE g.status = 1 ORDER BY g.salesCount DESC LIMIT 10")
    List<Game> findTop10BySalesCount();
    
    @Query("SELECT g FROM Game g WHERE g.status = :status AND g.developer = :developer")
    Page<Game> findByDeveloperAndStatus(@Param("developer") String developer, @Param("status") Integer status, Pageable pageable);
    
    @Query("SELECT g FROM Game g WHERE g.status = 1 AND g.publisher = :publisher")
    List<Game> findByPublisher(@Param("publisher") String publisher);
    
    @Query("SELECT g FROM Game g WHERE g.status = 1 AND CONCAT(',', g.category, ',') LIKE CONCAT('%,', :category, ',%')")
    List<Game> findByCategory(@Param("category") String category);
    
    Optional<Game> findByName(String name);
}
