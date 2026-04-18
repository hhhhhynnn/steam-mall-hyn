package com.steam.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "hot_sale")
public class HotSale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long gameId;

    @Column(nullable = false, length = 200)
    private String gameName;

    private String coverImage;

    @Column(nullable = false)
    private Long salesCount;

    private BigDecimal salesAmount;

    @Column(nullable = false)
    private Integer rank;

    @Column(nullable = false, length = 20)
    private String periodType;  // ALL-总榜，DAILY-日榜，WEEKLY-周榜，MONTHLY-月榜

    @Column(nullable = false)
    private LocalDate statDate;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}