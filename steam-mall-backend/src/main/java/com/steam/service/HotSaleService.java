package com.steam.service;

import com.steam.entity.Game;
import com.steam.entity.HotSale;
import com.steam.repository.GameRepository;
import com.steam.repository.HotSaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class HotSaleService {

    private final HotSaleRepository hotSaleRepository;
    private final GameRepository gameRepository;

    /**
     * 获取热销榜前 10 名
     */
    public List<HotSale> getTop10(String periodType) {
        LocalDate statDate = getStatDateByPeriod(periodType);
        return hotSaleRepository.findByPeriodTypeAndStatDateOrderByRankAsc(periodType, statDate);
    }

    /**
     * 更新热销榜 - 每 15 分钟执行一次
     */
    @Scheduled(fixedRate = 900000)  // 15 分钟 = 900000 毫秒
    @Transactional
    public void updateHotSaleRank() {
        updateHotSaleByPeriod("ALL");
    }

    /**
     * 根据周期更新热销榜
     */
    private void updateHotSaleByPeriod(String periodType) {
        LocalDate statDate = getStatDateByPeriod(periodType);

        // 获取销量前 10 的游戏
        List<Game> topGames = gameRepository.findTop10BySalesCount();

        // 先批量删除同周期旧榜单并立即 flush，避免同一事务中插入时触发唯一键冲突
        List<HotSale> existingRows = hotSaleRepository.findByPeriodTypeAndStatDateOrderByRankAsc(periodType, statDate);
        if (!existingRows.isEmpty()) {
            hotSaleRepository.deleteAllInBatch(existingRows);
            hotSaleRepository.flush();
        }

        // 插入新数据
        for (int i = 0; i < topGames.size(); i++) {
            Game game = topGames.get(i);

            HotSale hotSale = new HotSale();
            hotSale.setGameId(game.getId());
            hotSale.setGameName(game.getName());
            hotSale.setCoverImage(game.getCoverImage());
            hotSale.setSalesCount(game.getSalesCount());
            hotSale.setSalesAmount(game.getPrice());
            hotSale.setRank(i + 1);
            hotSale.setPeriodType(periodType);
            hotSale.setStatDate(statDate);

            hotSaleRepository.save(hotSale);
        }
    }

    /**
     * 根据周期类型获取统计日期
     */
    private LocalDate getStatDateByPeriod(String periodType) {
        switch (periodType) {
            case "DAILY":
                return LocalDate.now();
            case "WEEKLY":
                return LocalDate.now().minusWeeks(1);
            case "MONTHLY":
                return LocalDate.now().minusMonths(1);
            case "ALL":
            default:
                return LocalDate.of(2020, 1, 1);
        }
    }
}