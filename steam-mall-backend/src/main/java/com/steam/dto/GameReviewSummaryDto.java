package com.steam.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GameReviewSummaryDto {

    private int positiveReviews;
    private int negativeReviews;
    private int totalReviews;
    private int positiveRate;
}
