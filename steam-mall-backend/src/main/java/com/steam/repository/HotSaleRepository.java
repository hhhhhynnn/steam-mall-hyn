package com.steam.repository;

import com.steam.entity.Game;
import com.steam.entity.HotSale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface HotSaleRepository extends JpaRepository<HotSale, Long> {
    List<HotSale> findByPeriodTypeAndStatDateOrderByRankAsc(String periodType, LocalDate statDate);

    @Query("SELECT g FROM Game g WHERE g.status = 1 ORDER BY g.salesCount DESC LIMIT 10")
    List<Game> findTop10GamesBySales();

    void deleteByPeriodTypeAndStatDate(String periodType, LocalDate statDate);
}