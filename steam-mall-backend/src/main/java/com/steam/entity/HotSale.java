package com.steam.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "hot_sale")
public class HotSale {

    @Id
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

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
