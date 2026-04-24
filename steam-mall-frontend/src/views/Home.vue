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
            <h2>热门热销</h2>
            <router-link to="/hot-sale" class="view-all">查看全部</router-link>
          </div>
          <div class="hot-sale-list">
            <div
              v-for="(game, index) in hotSaleGames"
              :key="game.id"
              class="chart-item hot-sale-item"
              @click="goToGame(game.id)"
            >
              <span class="rank">{{ index + 1 }}</span>
              <img :src="game.coverImage" :alt="game.name" class="chart-image" />
              <div class="chart-info">
                <div class="chart-name">{{ game.name }}</div>
                <div class="chart-rating hot-sale-meta">
                  <span>销量 {{ game.salesCount }}</span>
                  <span class="hot-sale-price">¥{{ game.price }}</span>
                </div>
              </div>
            </div>
          </div>
        </section>

        <div class="charts-section">
          <h3>好评榜</h3>
          <div
            v-for="(game, index) in topRated"
            :key="game.id"
            class="chart-item"
            @click="goToGame(game.id)"
          >
            <span class="rank">{{ index + 1 }}</span>
            <img :src="game.coverImage" :alt="game.name" class="chart-image" />
            <div class="chart-info">
              <div class="chart-name">{{ game.name }}</div>
              <div class="chart-rating">
                <span>{{ calculateRating(game) }}% 好评</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="content">
        <section class="featured-section">
          <div class="section-header featured-header">
            <div>
              <h2>精选和推荐</h2>
            </div>
            <div class="featured-actions" v-if="featuredGames.length > 1">
              <button type="button" class="nav-btn" @click="prevFeatured" aria-label="上一张">
                ‹
              </button>
              <button type="button" class="nav-btn" @click="nextFeatured" aria-label="下一张">
                ›
              </button>
            </div>
          </div>

          <div
            v-if="currentFeatured"
            class="featured-hero"
            :style="{ backgroundImage: `linear-gradient(90deg, rgba(10,17,26,0.92) 0%, rgba(10,17,26,0.5) 45%, rgba(10,17,26,0.15) 100%), url(${currentFeatured.imageUrl})` }"
            @click="goToGame(currentFeatured.gameId)"
          >
            <div class="hero-content">
              <h3>{{ currentFeatured.title }}</h3>
              <p class="hero-description">
                {{ currentFeatured.shortDescription || '点击查看游戏详情、价格和更多内容。' }}
              </p>
              <div class="hero-meta">
                <span
                  v-for="item in parseGameCategories(currentFeatured)"
                  :key="item"
                  class="meta-tag"
                >
                  {{ item }}
                </span>
              </div>
              <div class="hero-footer">
                <div class="hero-price">
                  <span v-if="Number(currentFeatured.discount) > 0" class="discount">
                    -{{ Number(currentFeatured.discount) }}%
                  </span>
                  <span>¥{{ currentFeatured.finalPrice ?? currentFeatured.price }}</span>
                </div>
                <span class="detail-link">查看详情</span>
              </div>
            </div>

            <div class="hero-preview" v-if="currentFeatured.coverImage">
              <img :src="currentFeatured.coverImage" :alt="currentFeatured.gameName" />
            </div>
          </div>

          <div v-else class="featured-empty">
            暂无精选推荐，请先在后台配置首页投放。
          </div>

          <div v-if="featuredGames.length > 1" class="featured-thumbs">
            <button
              v-for="(game, index) in featuredGames"
              :key="game.carouselId"
              type="button"
              class="thumb-card"
              :class="{ active: index === featuredIndex }"
              @click="setFeatured(index)"
            >
              <img :src="game.imageUrl" :alt="game.title" />
              <div class="thumb-info">
                <span>{{ game.title }}</span>
                <small>{{ game.gameName }}</small>
              </div>
            </button>
          </div>
        </section>

        <div class="search-section">
          <el-input
            v-model="searchKeyword"
            placeholder="搜索游戏..."
            class="search-input"
            @keyup.enter="handleSearch"
          >
            <template #append>
              <el-button @click="handleSearch">搜索</el-button>
            </template>
          </el-input>
        </div>

        <div class="games-section">
          <h2>全部游戏</h2>
          <div class="games-grid">
            <div
              v-for="game in games"
              :key="game.id"
              class="game-card"
              @click="goToGame(game.id)"
            >
              <img :src="game.coverImage" :alt="game.name" class="game-image" />
              <div class="game-info">
                <div class="game-name">{{ game.name }}</div>
                <div class="game-tags">
                  <el-tag
                    v-for="cat in parseGameCategories(game)"
                    :key="cat"
                    size="small"
                  >
                    {{ cat }}
                  </el-tag>
                </div>
                <div class="game-price">
                  <span v-if="Number(game.discount) > 0" class="discount">-{{ Number(game.discount) }}%</span>
                  <span class="price">¥{{ game.finalPrice ?? game.price }}</span>
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
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getGames, getTopRatedGames } from '@/api/game'
import { getCategories, getFeaturedCarousels } from '@/api'
import { getHotSaleList } from '@/api/hotSale'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()

const categories = ref([])
const featuredGames = ref([])
const featuredIndex = ref(0)
const games = ref([])
const hotSaleGames = ref([])
const topRated = ref([])
const searchKeyword = ref('')
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

let featuredTimer = null

const currentFeatured = computed(() => featuredGames.value[featuredIndex.value] || null)

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
    const res = await getHotSaleList()
    hotSaleGames.value = (res || []).slice(0, 3).map(item => ({
      id: item.gameId,
      name: item.gameName,
      coverImage: item.coverImage,
      price: item.salesAmount,
      salesCount: item.salesCount
    }))
  } catch (error) {
    console.error('load hot sales failed', error)
  }
}

const loadTopRated = async () => {
  const res = await getTopRatedGames({ page: 0, size: 5 })
  topRated.value = res.content || []
}

const loadCategories = async () => {
  categories.value = await getCategories()
}

const loadFeaturedGames = async () => {
  featuredGames.value = await getFeaturedCarousels()
  featuredIndex.value = 0
  restartFeaturedTimer()
}

const handleSearch = () => {
  if (searchKeyword.value.trim()) {
    router.push({ path: '/search', query: { q: searchKeyword.value } })
  }
}

const goToGame = (id) => {
  router.push(`/game/${id}`)
}

const goToCategory = (category) => {
  router.push(`/category/${category}`)
}

const calculateRating = (game) => {
  const count = (game.positiveReviews || 0) + (game.negativeReviews || 0)
  if (!count) return 0
  return Math.round(((game.positiveReviews || 0) / count) * 100)
}

const parseGameCategories = (game) => {
  if (!game?.category) return []
  return String(game.category)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
}

const setFeatured = (index) => {
  featuredIndex.value = index
  restartFeaturedTimer()
}

const nextFeatured = () => {
  if (featuredGames.value.length <= 1) return
  featuredIndex.value = (featuredIndex.value + 1) % featuredGames.value.length
  restartFeaturedTimer()
}

const prevFeatured = () => {
  if (featuredGames.value.length <= 1) return
  featuredIndex.value = (featuredIndex.value - 1 + featuredGames.value.length) % featuredGames.value.length
  restartFeaturedTimer()
}

const restartFeaturedTimer = () => {
  if (featuredTimer) {
    clearInterval(featuredTimer)
    featuredTimer = null
  }

  if (featuredGames.value.length > 1) {
    featuredTimer = setInterval(() => {
      featuredIndex.value = (featuredIndex.value + 1) % featuredGames.value.length
    }, 5000)
  }
}

onMounted(() => {
  loadGames()
  loadHotSales()
  loadTopRated()
  loadCategories()
  loadFeaturedGames()
})

onBeforeUnmount(() => {
  if (featuredTimer) {
    clearInterval(featuredTimer)
  }
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

.category-section,
.charts-section,
.hot-sale-section {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.22);
  border-radius: 3px;
  padding: 15px;
  margin-bottom: 20px;
}

.category-section h3,
.charts-section h3,
.section-header h2 {
  color: #ffffff;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.view-all {
  color: #66c0f4;
  text-decoration: none;
  font-size: 13px;
}

.category-list {
  list-style: none;
  padding: 0;
  margin: 0;

  li {
    padding: 8px 10px;
    cursor: pointer;
    transition: all 0.3s;
    border-radius: 4px;
    color: #c7d5e0;

    &:hover {
      background: rgba(102, 192, 244, 0.2);
      color: #66c0f4;
    }
  }
}

.hot-sale-list {
  display: grid;
  gap: 8px;
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
}

.chart-name {
  color: #fff;
  font-size: 13px;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.chart-rating {
  color: #66c0f4;
  font-size: 12px;
}

.hot-sale-item .rank {
  background: linear-gradient(180deg, #67c1f5 0%, #2f6f94 100%);
}

.hot-sale-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.hot-sale-price {
  color: #a4d007;
  font-weight: 700;
}

.content {
  flex: 1;
  min-width: 0;
}

.featured-section {
  margin-bottom: 30px;
}

.featured-header {
  margin-bottom: 16px;
}

.eyebrow {
  margin: 0 0 8px;
  color: #67c1f5;
  font-size: 12px;
  letter-spacing: 0.18em;
}

.featured-header h2 {
  margin: 0;
  font-size: 28px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.45);
}

.featured-actions {
  display: flex;
  gap: 12px;
}

.nav-btn {
  width: 44px;
  height: 44px;
  border: none;
  border-radius: 999px;
  background: rgba(102, 192, 244, 0.14);
  color: #fff;
  font-size: 28px;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;

  &:hover {
    background: rgba(102, 192, 244, 0.35);
    transform: translateY(-1px);
  }
}

.featured-hero {
  min-height: 360px;
  border: 1px solid rgba(102, 192, 244, 0.24);
  border-radius: 6px;
  overflow: hidden;
  background-position: center;
  background-size: cover;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 280px;
  cursor: pointer;
  box-shadow: 0 16px 30px rgba(0, 0, 0, 0.28);
}

.hero-content {
  padding: 34px;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.hero-kicker {
  margin: 0 0 10px;
  color: #66c0f4;
  font-size: 13px;
}

.hero-content h3 {
  margin: 0 0 16px;
  font-size: 34px;
  color: #fff;
}

.hero-description {
  max-width: 680px;
  margin: 0 0 18px;
  line-height: 1.7;
  color: #d7e5f0;
}

.hero-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 20px;
}

.meta-tag {
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(103, 193, 245, 0.14);
  color: #c7e6ff;
  font-size: 12px;
}

.hero-footer {
  display: flex;
  align-items: center;
  gap: 16px;
}

.hero-price {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #fff;
  font-size: 26px;
  font-weight: 700;
}

.discount {
  background: #4c6b22;
  color: #a4d007;
  padding: 4px 8px;
  border-radius: 3px;
  font-size: 14px;
}

.detail-link {
  color: #66c0f4;
  font-size: 14px;
}

.hero-preview {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28px;
  background: rgba(5, 10, 15, 0.28);
}

.hero-preview img {
  width: 100%;
  border-radius: 8px;
  object-fit: cover;
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.35);
}

.featured-empty {
  min-height: 220px;
  border: 1px dashed rgba(102, 192, 244, 0.35);
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c7d5e0;
  background: rgba(17, 31, 46, 0.7);
}

.featured-thumbs {
  margin-top: 14px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
}

.thumb-card {
  border: 1px solid rgba(102, 192, 244, 0.15);
  border-radius: 6px;
  overflow: hidden;
  background: rgba(21, 37, 53, 0.95);
  color: #fff;
  padding: 0;
  cursor: pointer;
  text-align: left;
  transition: border-color 0.2s ease, transform 0.2s ease;

  &:hover,
  &.active {
    border-color: rgba(102, 192, 244, 0.55);
    transform: translateY(-2px);
  }

  img {
    width: 100%;
    height: 90px;
    object-fit: cover;
    display: block;
  }
}

.thumb-info {
  padding: 10px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;

  span {
    color: #fff;
    font-size: 14px;
    font-weight: 600;
  }

  small {
    color: #8fa7bf;
    font-size: 12px;
  }
}

.search-section {
  margin-bottom: 30px;
}

.search-input {
  max-width: 600px;
}

.games-section h2 {
  color: #fff;
  margin-bottom: 20px;
  font-size: 22px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
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
}

.game-card img,
.game-image {
  width: 100%;
  height: 160px;
  object-fit: cover;
}

.game-info {
  padding: 12px;
}

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
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.game-price {
  display: flex;
  align-items: center;
  gap: 8px;
}

.game-price .price {
  color: #c7d5e0;
  font-size: 14px;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}

@media (max-width: 1100px) {
  .main-content {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
  }

  .featured-hero {
    grid-template-columns: 1fr;
  }

  .hero-preview {
    display: none;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }

  .featured-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .hero-content {
    padding: 24px;
  }

  .hero-content h3 {
    font-size: 28px;
  }

  .featured-thumbs {
    grid-template-columns: 1fr;
  }
}
</style>
