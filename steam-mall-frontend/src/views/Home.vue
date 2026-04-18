<template>
  <div class="home">
    <Navbar />
    
    <div class="main-content">
      <div class="sidebar">
        <div class="category-section">
          <h3>浏览分类</h3>
          <ul class="category-list">
            <li 
              v-for="category in categories" 
              :key="category.id"
              @click="goToCategory(category.name)"
            >
              {{ category.name }}
            </li>
          </ul>
        </div>

        <section class="hot-sale-section">
          <div class="section-header">
            <h2>🔥 热销榜</h2>
            <router-link to="/hot-sale" class="view-all">查看全部</router-link>
          </div>
          <div class="hot-sale-grid">
            <div
                v-for="game in hotSaleGames"
                :key="game.id"
                class="game-card"
                @click="goToGameDetail(game.id)">
              <img :src="game.coverImage" :alt="game.name">
              <h3>{{ game.name }}</h3>
              <div class="price">¥{{ game.price }}</div>
            </div>
          </div>
        </section>

        <div class="charts-section">
          <h3>好评排行榜</h3>
          <div class="chart-item" v-for="(game, index) in topRated" :key="game.id" @click="goToGame(game.id)">
            <span class="rank">{{ index + 1 }}</span>
            <img :src="game.coverImage" :alt="game.name" class="chart-image" />
            <div class="chart-info">
              <div class="chart-name">{{ game.name }}</div>
              <div class="chart-rating">
                <el-icon><Star /></el-icon>
                <span>{{ calculateRating(game) }}% 好评</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="content">
        <div class="carousel-section">
          <el-carousel :interval="5000" arrow="always" height="350px">
            <el-carousel-item v-for="carousel in carousels" :key="carousel.id">
              <img :src="carousel.imageUrl" :alt="carousel.title" class="carousel-image" />
            </el-carousel-item>
          </el-carousel>
        </div>

        <div class="search-section">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索游戏..."
            class="search-input"
            @keyup.enter="handleSearch"
          >
            <template #append>
              <el-button @click="handleSearch">
                <el-icon><Search /></el-icon>
              </el-button>
            </template>
          </el-input>
        </div>

        <div class="games-section">
          <h2>全部游戏</h2>
          <div class="games-grid">
            <div 
              class="game-card" 
              v-for="game in games" 
              :key="game.id"
              @click="goToGame(game.id)"
            >
              <img :src="game.coverImage" :alt="game.name" class="game-image" />
              <div class="game-info">
                <div class="game-name">{{ game.name }}</div>
                <div class="game-tags">
                  <el-tag size="small" v-for="cat in parseGameCategories(game)" :key="cat">{{ cat }}</el-tag>
                </div>
                <div class="game-price">
                  <span v-if="game.discount > 0" class="discount">-{{ game.discount }}%</span>
                  <span class="price">¥{{ game.finalPrice || game.price }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="pagination">
            <el-pagination
              v-model:current-page="currentPage"
              :page-size="pageSize"
              :total="total"
              layout="prev, pager, next"
              @current-change="loadGames"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getGames, getTopRatedGames } from '@/api/game'
import { getCategories, getCarousels } from '@/api'
import { getHotSaleList } from '@/api/hotSale'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()

const categories = ref([])
const carousels = ref([])
const games = ref([])
const hotSaleGames = ref([])  // 热销榜游戏
const topRated = ref([])
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

const loadGames = async () => {
  const res = await getGames({
    page: currentPage.value - 1,
    size: pageSize.value
  })
  games.value = res.content || []
  total.value = res.totalElements || 0
}

const loadHotSales = async () => {
  try {
    const res = await getHotSaleList('ALL')
    // 从热销榜数据中提取游戏信息
    hotSaleGames.value = (res || []).map(item => ({
      id: item.gameId,
      name: item.gameName,
      coverImage: item.coverImage,
      price: item.salesAmount
    }))
  } catch (error) {
    console.error('加载热销榜失败:', error)
  }
}

const loadTopRated = async () => {
  const res = await getTopRatedGames({ page: 0, size: 5 })
  topRated.value = res.content || []
}

const loadCategories = async () => {
  categories.value = await getCategories()
}

const loadCarousels = async () => {
  carousels.value = await getCarousels()
}

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/search', query: { q: searchKeyword.value } })
  }
}

const goToGame = (id) => {
  router.push(`/game/${id}`)
}

const goToGameDetail = (id) => {
  router.push(`/game/${id}`)
}

const goToCategory = (category) => {
  router.push(`/category/${category}`)
}

const calculateRating = (game) => {
  const total = game.positiveReviews + game.negativeReviews
  if (total === 0) return 0
  return Math.round((game.positiveReviews / total) * 100)
}

const parseGameCategories = (game) => {
  if (!game?.category) return []
  return String(game.category)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
}

onMounted(() => {
  loadGames()
  loadHotSales()  // 加载热销榜
  loadTopRated()
  loadCategories()
  loadCarousels()
})
</script>

<style scoped lang="scss">
.home {
  min-height: 100vh;
  background: transparent;
}

.main-content {
  display: flex;
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  gap: 20px;
}

.sidebar {
  width: 300px;
  flex-shrink: 0;
}

.category-section {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.22);
  border-radius: 3px;
  padding: 15px;
  margin-bottom: 20px;

  h3 {
    color: #ffffff;
    margin-bottom: 10px;
    font-size: 16px;
  }
}

.category-list {
  list-style: none;

  li {
    padding: 8px 10px;
    cursor: pointer;
    transition: all 0.3s;
    border-radius: 4px;

    &:hover {
      background: rgba(102, 192, 244, 0.2);
      color: #66c0f4;
    }
  }
}

.charts-section {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.22);
  border-radius: 3px;
  padding: 15px;
  margin-bottom: 20px;

  h3 {
    color: #ffffff;
    margin-bottom: 10px;
    font-size: 16px;
  }
}

.chart-item {
  display: flex;
  align-items: center;
  padding: 8px;
  cursor: pointer;
  transition: all 0.3s;
  border-radius: 4px;

  &:hover {
    background: rgba(102, 192, 244, 0.2);
  }

  .rank {
    width: 24px;
    height: 24px;
    background: #66c0f4;
    color: #fff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 10px;
    font-size: 12px;
    font-weight: bold;
  }

  .chart-image {
    width: 60px;
    height: 34px;
    object-fit: cover;
    border-radius: 4px;
    margin-right: 10px;
  }

  .chart-info {
    flex: 1;
    min-width: 0;

    .chart-name {
      color: #fff;
      font-size: 13px;
      margin-bottom: 4px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .chart-price {
      display: flex;
      align-items: center;
      gap: 5px;

      .discount {
        background: #4c6b22;
        color: #a4d007;
        padding: 2px 4px;
        border-radius: 2px;
        font-size: 11px;
      }

      .price {
        color: #c7d5e0;
        font-size: 13px;
      }
    }

    .chart-rating {
      display: flex;
      align-items: center;
      gap: 4px;
      color: #66c0f4;
      font-size: 12px;
    }
  }
}

.content {
  flex: 1;
  min-width: 0;
}

.carousel-section {
  margin-bottom: 30px;

  .carousel-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.search-section {
  margin-bottom: 30px;

  .search-input {
    max-width: 600px;
  }
}

.games-section {
  h2 {
    color: #fff;
    margin-bottom: 20px;
    font-size: 22px;
    text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
  }
}

.games-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.game-card {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.96) 0%, rgba(24, 38, 56, 0.96) 100%);
  border: 1px solid rgba(102, 192, 244, 0.16);
  border-radius: 3px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-3px);
    border-color: rgba(102, 192, 244, 0.45);
    box-shadow: 0 10px 22px rgba(0, 0, 0, 0.38);
  }

  .game-image {
    width: 100%;
    height: 160px;
    object-fit: cover;
  }

  .game-info {
    padding: 12px;

    .game-name {
      color: #fff;
      font-size: 14px;
      margin-bottom: 8px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .game-tags {
      margin-bottom: 8px;
    }

    .game-price {
      display: flex;
      align-items: center;
      gap: 8px;

      .discount {
        background: #4c6b22;
        color: #a4d007;
        padding: 2px 6px;
        border-radius: 2px;
        font-size: 12px;
      }

      .price {
        color: #c7d5e0;
        font-size: 14px;
      }
    }
  }
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}
</style>