package com.steam.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Entity
@Table(name = "game")
public class Game implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String shortDescription;

    @Column(length = 255)
    private String coverImage;

    @Column(length = 255)
    private String bannerImage;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price = BigDecimal.ZERO;

    @Column(precision = 5, scale = 2)
    private BigDecimal discount = BigDecimal.ZERO;

    @Column(precision = 10, scale = 2)
    private BigDecimal finalPrice;

    @Column(length = 100)
    private String developer;

    @Column(length = 100)
    private String publisher;

    private LocalDate releaseDate;

    @Column(length = 255)
    private String category;

    @Column(length = 500)
    private String tags;

    @Column(length = 255)
    private String videoUrl;

    @Column(columnDefinition = "TEXT")
    private String images;

    @Column(columnDefinition = "TEXT")
    private String systemRequirements;

    @Column(nullable = false)
    private Integer status = 1;


    private Long viewCount = 0L;


    private Long salesCount = 0L;


    private Integer positiveReviews = 0;


    private Integer negativeReviews = 0;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    @PreUpdate
    private void calculateFinalPrice() {
        if (discount != null && price != null) {
            this.finalPrice = price.multiply(
                BigDecimal.valueOf(1).subtract(discount.divide(BigDecimal.valueOf(100)))
            );
        }
    }
}
