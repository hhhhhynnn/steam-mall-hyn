<template>
  <div class="hot-sale-page">
    <div class="container">
      <h2 class="page-title">🔥 热销榜 TOP 10</h2>

      <div class="period-selector">
        <el-radio-group v-model="periodType" @change="fetchHotSaleList">
          <el-radio-button label="ALL">总榜</el-radio-button>
          <el-radio-button label="DAILY">日榜</el-radio-button>
          <el-radio-button label="WEEKLY">周榜</el-radio-button>
          <el-radio-button label="MONTHLY">月榜</el-radio-button>
        </el-radio-group>
      </div>

      <div class="hot-sale-list">
        <div
            v-for="(item, index) in hotSaleList"
            :key="item.id"
            class="hot-sale-item"
            :class="{ 'top-3': index < 3 }"
            @click="goToGameDetail(item.gameId)">

          <div class="rank" :class="'rank-' + (index + 1)">
            {{ index + 1 }}
          </div>

          <div class="game-cover">
            <img :src="item.coverImage" :alt="item.gameName">
          </div>

          <div class="game-info">
            <h3 class="game-name">{{ item.gameName }}</h3>
            <div class="game-meta">
              <span class="sales-count">销量：{{ item.salesCount }}</span>
              <span class="price">¥{{ item.salesAmount }}</span>
            </div>
          </div>

          <div class="hot-icon" v-if="index < 3">🔥</div>
        </div>
      </div>

      <div v-if="hotSaleList.length === 0" class="empty-state">
        <el-empty description="暂无热销数据"></el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getHotSaleList } from '@/api/hotSale'

const router = useRouter()
const periodType = ref('ALL')
const hotSaleList = ref([])

const fetchHotSaleList = async () => {
  try {
    const res = await getHotSaleList(periodType.value)
    hotSaleList.value = res
  } catch (error) {
    console.error('获取热销榜失败:', error)
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
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  padding: 40px 20px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

.page-title {
  color: #fff;
  font-size: 32px;
  text-align: center;
  margin-bottom: 30px;
}

.period-selector {
  text-align: center;
  margin-bottom: 30px;
}

.hot-sale-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.hot-sale-item {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.hot-sale-item:hover {
  transform: translateY(-5px);
  background: rgba(255, 255, 255, 0.15);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.hot-sale-item.top-3 {
  background: linear-gradient(135deg, rgba(255, 215, 0, 0.2) 0%, rgba(255, 255, 255, 0.1) 100%);
  border: 1px solid rgba(255, 215, 0, 0.3);
}

.rank {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #333;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 18px;
  flex-shrink: 0;
}

.rank-1 {
  background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
  box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
}

.rank-2 {
  background: linear-gradient(135deg, #C0C0C0 0%, #808080 100%);
}

.rank-3 {
  background: linear-gradient(135deg, #CD7F32 0%, #8B4513 100%);
}

.game-cover {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.game-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.game-info {
  flex: 1;
  min-width: 0;
}

.game-name {
  color: #fff;
  font-size: 16px;
  margin: 0 0 8px 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.game-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sales-count {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.price {
  color: #1a9bf4;
  font-weight: bold;
  font-size: 16px;
}

.hot-icon {
  position: absolute;
  top: 10px;
  right: 10px;
  font-size: 24px;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
}
</style>