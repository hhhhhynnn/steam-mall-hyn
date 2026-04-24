package com.steam.repository;

import com.steam.entity.HotSale;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotSaleRepository extends JpaRepository<HotSale, Long> {

    List<HotSale> findAllByOrderByRankAsc();
}
