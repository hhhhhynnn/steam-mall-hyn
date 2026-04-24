package com.steam.repository;

import com.steam.entity.Carousel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CarouselRepository extends JpaRepository<Carousel, Long> {
    
    List<Carousel> findByStatusOrderBySortOrder(Integer status);

    List<Carousel> findAllByOrderBySortOrderAscIdAsc();
}
