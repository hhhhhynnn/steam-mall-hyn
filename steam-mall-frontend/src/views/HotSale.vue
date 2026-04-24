<template>
  <div class="hot-sale-page">
    <div class="container">
      <div class="hero">
        <p class="eyebrow">TOP SELLERS</p>
        <h1>热销总榜</h1>
        <p class="subtitle">当前平台累计销量最高的 10 款游戏，点击任意条目可直接进入详情页。</p>
      </div>

      <div class="hot-sale-board">
        <div
          v-for="(item, index) in hotSaleList"
          :key="item.gameId"
          class="board-item"
          :class="{ champion: index === 0 }"
          @click="goToGameDetail(item.gameId)"
        >
          <div class="board-rank">
            <span class="rank-number">#{{ index + 1 }}</span>
          </div>

          <div class="board-cover">
            <img :src="item.coverImage" :alt="item.gameName">
          </div>

          <div class="board-main">
            <div class="board-top">
              <h3>{{ item.gameName }}</h3>
              <span class="board-badge" v-if="index < 3">HOT</span>
            </div>
            <div class="board-meta">
              <span class="sales">累计销量 {{ item.salesCount }}</span>
              <span class="price">¥{{ item.salesAmount }}</span>
            </div>
          </div>
        </div>
      </div>

      <div v-if="hotSaleList.length === 0" class="empty-state">
        <el-empty description="暂无热销总榜数据"></el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getHotSaleList } from '@/api/hotSale'

const router = useRouter()
const hotSaleList = ref([])

const fetchHotSaleList = async () => {
  try {
    hotSaleList.value = await getHotSaleList()
  } catch (error) {
    console.error('get hot sale list failed', error)
  }
}

const goToGameDetail = (gameId) => {
  router.push(`/game/${gameId}`)
}

onMounted(() => {
  fetchHotSaleList()
})
</script>

<style scoped>
.hot-sale-page {
  min-height: 100vh;
  background:
    radial-gradient(circle at top, rgba(72, 115, 145, 0.22), transparent 30%),
    linear-gradient(180deg, #121a24 0%, #1b2838 55%, #16202d 100%);
  padding: 40px 20px 70px;
}

.container {
  max-width: 1180px;
  margin: 0 auto;
}

.hero {
  margin-bottom: 28px;
}

.eyebrow {
  margin: 0 0 10px;
  color: #66c0f4;
  font-size: 12px;
  letter-spacing: 0.18em;
}

.hero h1 {
  margin: 0 0 12px;
  color: #fff;
  font-size: 40px;
}

.subtitle {
  margin: 0;
  color: #a7bacc;
  font-size: 15px;
}

.hot-sale-board {
  display: grid;
  gap: 14px;
}

.board-item {
  display: grid;
  grid-template-columns: 90px 300px minmax(0, 1fr);
  align-items: center;
  gap: 18px;
  padding: 18px;
  border: 1px solid rgba(102, 192, 244, 0.14);
  border-radius: 8px;
  background: linear-gradient(90deg, rgba(34, 51, 68, 0.96) 0%, rgba(24, 38, 55, 0.96) 100%);
  cursor: pointer;
  transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
}

.board-item:hover {
  transform: translateY(-2px);
  border-color: rgba(102, 192, 244, 0.35);
  box-shadow: 0 14px 24px rgba(0, 0, 0, 0.28);
}

.board-item.champion {
  background: linear-gradient(90deg, rgba(61, 47, 22, 0.95) 0%, rgba(31, 45, 62, 0.96) 50%, rgba(24, 38, 55, 0.96) 100%);
  border-color: rgba(212, 175, 55, 0.38);
}

.board-rank {
  display: flex;
  align-items: center;
  justify-content: center;
}

.rank-number {
  color: #fff;
  font-size: 26px;
  font-weight: 800;
}

.board-cover img {
  width: 100%;
  height: 140px;
  object-fit: cover;
  border-radius: 6px;
  display: block;
}

.board-main {
  min-width: 0;
}

.board-top {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.board-top h3 {
  margin: 0;
  color: #fff;
  font-size: 24px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.board-badge {
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(255, 208, 92, 0.18);
  color: #ffd166;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.board-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.sales {
  color: #8fa7bf;
  font-size: 15px;
}

.price {
  color: #a4d007;
  font-size: 28px;
  font-weight: 800;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
}

@media (max-width: 900px) {
  .board-item {
    grid-template-columns: 72px 1fr;
  }

  .board-cover {
    grid-column: 2;
  }

  .board-main {
    grid-column: 2;
  }
}

@media (max-width: 640px) {
  .hot-sale-page {
    padding: 28px 14px 50px;
  }

  .hero h1 {
    font-size: 30px;
  }

  .board-item {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .board-rank,
  .board-cover,
  .board-main {
    grid-column: auto;
  }

  .board-rank {
    justify-content: flex-start;
  }

  .board-cover img {
    height: 180px;
  }

  .board-top,
  .board-meta {
    flex-direction: column;
    align-items: flex-start;
  }

  .price {
    font-size: 24px;
  }
}
</style>
