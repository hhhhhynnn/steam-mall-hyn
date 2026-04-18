<template>
  <div class="game-detail">
    <Navbar />
    
    <div class="detail-content" v-if="game">
      <div class="game-banner">
        <img :src="game.bannerImage || game.coverImage" :alt="game.name" />
      </div>

      <div class="detail-container">
        <div class="main-section">
          <h1 class="game-title">{{ game.name }}</h1>
          
          <div class="game-media">
            <video 
              v-if="game.videoUrl" 
              :src="game.videoUrl" 
              controls 
              class="game-video"
            />
            
            <div class="game-screenshots" v-if="gameImages.length > 0">
              <img 
                v-for="(img, index) in gameImages" 
                :key="index"
                :src="img" 
                :alt="game.name"
                class="screenshot"
              />
            </div>
          </div>

          <div class="game-description">
            <h3>游戏介绍</h3>
            <p>{{ game.description || game.shortDescription }}</p>
          </div>

          <div class="system-requirements" v-if="game.systemRequirements">
            <h3>系统需求</h3>
            <pre>{{ game.systemRequirements }}</pre>
          </div>

          <div class="reviews-section">
            <h3>玩家评价</h3>
            <div class="review-summary">
              <div class="review-stat">
                <span class="positive">{{ game.positiveReviews }}</span>
                <span>好评</span>
              </div>
              <div class="review-stat">
                <span class="negative">{{ game.negativeReviews }}</span>
                <span>差评</span>
              </div>
              <div class="review-rate">
                {{ calculateRating }}% 好评率
              </div>
            </div>

            <div class="reviews-list">
              <div class="review-item" v-for="review in reviews" :key="review.id">
                <div class="review-header">
                  <span :class="['review-type', review.isPositive === 1 ? 'positive' : 'negative']">
                    {{ review.isPositive === 1 ? '推荐' : '不推荐' }}
                  </span>
                  <span class="review-time">{{ formatDate(review.createdAt) }}</span>
                </div>
                <div class="review-content" v-if="review.content">
                  {{ review.content }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="sidebar-section">
          <div class="purchase-card">
            <img :src="game.coverImage" :alt="game.name" class="purchase-cover" />
            
            <div class="purchase-info">
              <div class="price-section" v-if="game.price > 0">
                <div class="discount" v-if="game.discount > 0">
                  -{{ game.discount }}%
                </div>
                <div class="prices">
                  <span class="original-price" v-if="game.discount > 0">¥{{ game.price }}</span>
                  <span class="final-price">¥{{ game.finalPrice || game.price }}</span>
                </div>
              </div>
              <div class="free-tag" v-else>
                免费开玩
              </div>
            </div>

            <div class="purchase-actions" v-if="!ownsGame">
              <el-button type="primary" style="width: 100%" @click="handlePurchase">
                {{ game.price > 0 ? '立即购买' : '获取游戏' }}
              </el-button>
            </div>
            <div class="owned-tag" v-else>
              <el-tag type="success" size="large">已在库中</el-tag>
            </div>

            <div class="game-meta">
              <div class="meta-item" v-if="game.developer">
                <span class="meta-label">开发商:</span>
                <span class="meta-value" @click="goToDeveloper">{{ game.developer }}</span>
              </div>
              <div class="meta-item" v-if="game.publisher">
                <span class="meta-label">发行商:</span>
                <span class="meta-value" @click="goToPublisher">{{ game.publisher }}</span>
              </div>
              <div class="meta-item" v-if="game.releaseDate">
                <span class="meta-label">发布日期:</span>
                <span class="meta-value">{{ game.releaseDate }}</span>
              </div>
              <div class="meta-item" v-if="gameCategories.length > 0">
                <span class="meta-label">分类:</span>
                <div class="meta-categories">
                  <span
                    v-for="cat in gameCategories"
                    :key="cat"
                    class="meta-value"
                    @click="goToCategory(cat)"
                  >
                    {{ cat }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="loading" v-else-if="loading">
      <el-icon class="is-loading"><Loading /></el-icon>
      <span>加载中...</span>
    </div>
    <div class="loading" v-else>
      <span>{{ loadError || '游戏详情加载失败' }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getGameById } from '@/api/game'
import { getGameReviews, checkOwnership, createOrder } from '@/api'
import { useUserStore } from '@/stores/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Loading } from '@element-plus/icons-vue'
import Navbar from '@/components/Navbar.vue'
import dayjs from 'dayjs'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const game = ref(null)
const reviews = ref([])
const ownsGame = ref(false)
const gameImages = ref([])
const loading = ref(true)
const loadError = ref('')

const calculateRating = computed(() => {
  if (!game.value) return 0
  const total = game.value.positiveReviews + game.value.negativeReviews
  if (total === 0) return 0
  return Math.round((game.value.positiveReviews / total) * 100)
})

const gameCategories = computed(() => {
  if (!game.value?.category) return []
  return String(game.value.category)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
})

const loadGame = async () => {
  loading.value = true
  loadError.value = ''
  try {
    game.value = await getGameById(route.params.id)
    if (game.value.images) {
      try {
        gameImages.value = JSON.parse(game.value.images) || []
      } catch (e) {
        gameImages.value = []
      }
    }
  } catch (error) {
    const message = error?.message || '游戏详情加载失败'
    loadError.value = message
    ElMessage.error(message)
    game.value = null
  } finally {
    loading.value = false
  }
}

const loadReviews = async () => {
  try {
    const res = await getGameReviews(route.params.id, { page: 0, size: 10 })
    reviews.value = res.content || []
  } catch (error) {
    console.error(error)
  }
}

const checkOwnershipStatus = async () => {
  if (userStore.isLoggedIn) {
    try {
      ownsGame.value = await checkOwnership(route.params.id)
    } catch (error) {
      ownsGame.value = false
    }
  }
}

const handlePurchase = async () => {
  if (!userStore.isLoggedIn) {
    ElMessageBox.alert('请先登录', '提示', {
      confirmButtonText: '去登录',
      callback: () => router.push('/login')
    })
    return
  }

  try {
    const order = await createOrder(route.params.id)
    ElMessage.success(`购买成功！激活码：${order.activationCode}`)
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

const goToDeveloper = () => {
  if (game.value && game.value.developer) {
    router.push(`/developer/${game.value.developer}`)
  }
}

const goToPublisher = () => {
  if (game.value && game.value.publisher) {
    router.push({ path: '/search', query: { publisher: game.value.publisher } })
  }
}

const goToCategory = (categoryName) => {
  if (categoryName) {
    router.push(`/category/${categoryName}`)
  }
}

const formatDate = (date) => {
  return dayjs(date).format('YYYY-MM-DD')
}

onMounted(() => {
  loadGame()
  loadReviews()
  checkOwnershipStatus()
})
</script>

<style scoped lang="scss">
.game-detail {
  min-height: 100vh;
  background: transparent;
}

.detail-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.game-banner {
  margin: -20px -20px 20px;
  
  img {
    width: 100%;
    height: 420px;
    object-fit: cover;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  }
}

.detail-container {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 30px;
}

.main-section {
  min-width: 0;
}

.game-title {
  color: #ffffff;
  font-size: 32px;
  margin-bottom: 20px;
}

.game-media {
  margin-bottom: 30px;

  .game-video {
    width: 100%;
    max-height: 500px;
    margin-bottom: 20px;
    border-radius: 4px;
  }

  .game-screenshots {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 10px;

    .screenshot {
      width: 100%;
      height: 120px;
      object-fit: cover;
      border-radius: 4px;
      cursor: pointer;
      transition: transform 0.3s;

      &:hover {
        transform: scale(1.05);
      }
    }
  }
}

.game-description {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.2);
  padding: 20px;
  border-radius: 3px;
  margin-bottom: 20px;

  h3 {
    color: #ffffff;
    margin-bottom: 10px;
  }

  p {
    color: #c7d5e0;
    line-height: 1.6;
  }
}

.system-requirements {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.2);
  padding: 20px;
  border-radius: 3px;
  margin-bottom: 20px;

  h3 {
    color: #ffffff;
    margin-bottom: 10px;
  }

  pre {
    color: #c7d5e0;
    white-space: pre-wrap;
    font-family: inherit;
  }
}

.reviews-section {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.2);
  padding: 20px;
  border-radius: 3px;

  h3 {
    color: #ffffff;
    margin-bottom: 15px;
  }

  .review-summary {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);

    .review-stat {
      display: flex;
      flex-direction: column;
      align-items: center;

      .positive {
        color: #66c0f4;
        font-size: 24px;
        font-weight: bold;
      }

      .negative {
        color: #ff4444;
        font-size: 24px;
        font-weight: bold;
      }
    }

    .review-rate {
      font-size: 20px;
      color: #a4d007;
      font-weight: bold;
    }
  }

  .reviews-list {
    .review-item {
      padding: 15px 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.05);

      .review-header {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;

        .review-type {
          padding: 4px 8px;
          border-radius: 2px;
          font-size: 12px;

          &.positive {
            background: #66c0f4;
            color: #fff;
          }

          &.negative {
            background: #ff4444;
            color: #fff;
          }
        }

        .review-time {
          color: #8b929a;
          font-size: 12px;
        }
      }

      .review-content {
        color: #c7d5e0;
        line-height: 1.6;
      }
    }
  }
}

.sidebar-section {
  position: sticky;
  top: 100px;
  height: fit-content;
}

.purchase-card {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.98) 0%, rgba(24, 38, 56, 0.98) 100%);
  border: 1px solid rgba(102, 192, 244, 0.28);
  border-radius: 3px;
  padding: 20px;
  position: sticky;
  top: 100px;

  .purchase-cover {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 4px;
    margin-bottom: 20px;
  }

  .purchase-info {
    margin-bottom: 20px;

    .price-section {
      display: flex;
      align-items: center;
      gap: 10px;

      .discount {
        background: #4c6b22;
        color: #a4d007;
        padding: 4px 8px;
        border-radius: 2px;
        font-size: 16px;
        font-weight: bold;
      }

      .prices {
        display: flex;
        align-items: center;
        gap: 10px;

        .original-price {
          color: #738895;
          text-decoration: line-through;
          font-size: 14px;
        }

        .final-price {
          color: #beee11;
          font-size: 26px;
          font-weight: bold;
        }
      }
    }

    .free-tag {
      background: #4c6b22;
      color: #a4d007;
      padding: 10px;
      text-align: center;
      border-radius: 4px;
      font-size: 18px;
      font-weight: bold;
    }
  }

  .owned-tag {
    text-align: center;
    margin: 20px 0;
  }

  .game-meta {
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);

    .meta-item {
      display: flex;
      margin-bottom: 10px;
      font-size: 13px;

      .meta-label {
        color: #8b929a;
        margin-right: 8px;
        min-width: 70px;
      }

      .meta-value {
        color: #66c0f4;
        cursor: pointer;
        margin-right: 10px;

        &:hover {
          text-decoration: underline;
        }
      }

      .meta-categories {
        display: flex;
        flex-wrap: wrap;
      }
    }
  }

  :deep(.el-button--primary) {
    background: linear-gradient(180deg, #8bc53f 0%, #5fa720 100%);
    border: none;
    color: #fff;
    font-weight: 600;
  }

  :deep(.el-button--primary:hover) {
    background: linear-gradient(180deg, #9adf49 0%, #67b128 100%);
  }
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 400px;
  color: #ffffff;
  gap: 20px;

  .is-loading {
    font-size: 48px;
  }
}
</style>
