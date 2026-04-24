package com.steam.service;

import com.steam.entity.Game;
import com.steam.entity.HotSale;
import com.steam.repository.GameRepository;
import com.steam.repository.HotSaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HotSaleService {

    private final HotSaleRepository hotSaleRepository;
    private final GameRepository gameRepository;

    public List<HotSale> getTop10() {
        List<HotSale> hotSales = hotSaleRepository.findAllByOrderByRankAsc();
        if (hotSales.isEmpty()) {
            return refreshTop10();
        }
        return hotSales;
    }

    @Transactional
    public List<HotSale> refreshTop10() {
        List<Game> topGames = gameRepository.findTopGames(PageRequest.of(0, 10)).getContent();

        hotSaleRepository.deleteAllInBatch();
        hotSaleRepository.flush();

        List<HotSale> hotSales = java.util.stream.IntStream.range(0, topGames.size())
                .mapToObj(index -> mapToHotSale(topGames.get(index), index + 1))
                .toList();

        hotSaleRepository.saveAll(hotSales);
        hotSaleRepository.flush();

        return hotSaleRepository.findAllByOrderByRankAsc();
    }

    private HotSale mapToHotSale(Game game, int rank) {
        HotSale hotSale = new HotSale();
        hotSale.setGameId(game.getId());
        hotSale.setGameName(game.getName());
        hotSale.setCoverImage(game.getCoverImage());
        hotSale.setSalesCount(game.getSalesCount());
        hotSale.setSalesAmount(game.getFinalPrice() != null ? game.getFinalPrice() : game.getPrice());
        hotSale.setRank(rank);
        return hotSale;
    }
}
