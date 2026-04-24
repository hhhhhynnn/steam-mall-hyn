<template>
  <div class="game-detail">
    <Navbar />

    <div v-if="game" class="detail-content">
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

            <div v-if="gameImages.length > 0" class="game-screenshots">
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

          <div v-if="game.systemRequirements" class="system-requirements">
            <h3>系统需求</h3>
            <pre>{{ game.systemRequirements }}</pre>
          </div>

          <div class="reviews-section">
            <div class="reviews-header">
              <div>
                <h3>玩家评论</h3>
                <p>按最新发布排序展示，首页好评榜使用真实好评率排名。</p>
              </div>
            </div>

            <div class="review-summary">
              <div class="review-stat">
                <span class="positive">{{ reviewSummary.positiveReviews }}</span>
                <span>好评</span>
              </div>
              <div class="review-stat">
                <span class="negative">{{ reviewSummary.negativeReviews }}</span>
                <span>差评</span>
              </div>
              <div class="review-rate">
                <strong>{{ reviewSummary.positiveRate }}%</strong>
                <span>好评率</span>
              </div>
              <div class="review-total">
                <strong>{{ reviewSummary.totalReviews }}</strong>
                <span>总评测</span>
              </div>
            </div>

            <div class="review-editor">
              <template v-if="!userStore.isLoggedIn">
                <p>登录后可查看自己是否拥有该游戏并发表评论。</p>
                <el-button type="primary" @click="router.push('/login')">去登录</el-button>
              </template>
              <template v-else-if="!ownsGame">
                <p>只有游戏库中拥有该游戏的用户才可以发表评论。</p>
              </template>
              <template v-else>
                <h4>{{ myReview?.id ? '修改你的评论' : '发表你的评论' }}</h4>
                <el-radio-group v-model="reviewForm.isPositive" class="review-radio-group">
                  <el-radio-button :label="1">
                    <span class="steam-vote-card positive-card">
                      <span class="vote-badge">👍</span>
                      <span class="vote-copy">
                        <strong>好评</strong>
                      </span>
                    </span>
                  </el-radio-button>
                  <el-radio-button :label="0">
                    <span class="steam-vote-card negative-card">
                      <span class="vote-badge">👎</span>
                      <span class="vote-copy">
                        <strong>差评</strong>
                      </span>
                    </span>
                  </el-radio-button>
                </el-radio-group>
                <el-input
                  v-model="reviewForm.content"
                  type="textarea"
                  :rows="4"
                  maxlength="500"
                  show-word-limit
                  class="review-textarea"
                  placeholder="分享一下你的游玩体验，可留空只提交好评/差评。"
                />
                <div class="review-editor-actions">
                  <el-button
                    type="primary"
                    :loading="submittingReview"
                    @click="handleSubmitReview"
                  >
                    {{ myReview?.id ? '更新评论' : '发布评论' }}
                  </el-button>
                  <el-button
                    v-if="myReview?.id"
                    :loading="deletingReview"
                    @click="handleDeleteReview"
                  >
                    删除评论
                  </el-button>
                </div>
              </template>
            </div>

            <div class="reviews-list">
              <div v-if="reviews.length === 0" class="empty-reviews">
                暂无玩家评论，成为第一个发表看法的人。
              </div>
              <div v-for="review in reviews" :key="review.id" class="review-item">
                <div class="review-header-row">
                  <div class="review-user">
                    <img
                      v-if="review.userAvatar"
                      :src="review.userAvatar"
                      :alt="review.username"
                      class="review-avatar"
                    />
                    <div v-else class="review-avatar placeholder">
                      {{ (review.username || '玩').slice(0, 1) }}
                    </div>
                    <div>
                      <div class="review-username">{{ review.username }}</div>
                      <div class="review-time">{{ formatDate(review.createdAt) }}</div>
                    </div>
                  </div>
                  <span :class="['review-type', review.isPositive === 1 ? 'positive' : 'negative']">
                    {{ review.isPositive === 1 ? '好评' : '差评' }}
                  </span>
                </div>
                <div v-if="review.content" class="review-content">
                  {{ review.content }}
                </div>
                <div v-else class="review-content empty">该玩家只提交了好评/差评，没有填写文字内容。</div>
              </div>
            </div>
          </div>
        </div>

        <div class="sidebar-section">
          <div class="purchase-card">
            <img :src="game.coverImage" :alt="game.name" class="purchase-cover" />

            <div class="purchase-info">
              <div v-if="game.price > 0" class="price-section">
                <div v-if="game.discount > 0" class="discount">
                  -{{ game.discount }}%
                </div>
                <div class="prices">
                  <span v-if="game.discount > 0" class="original-price">¥{{ game.price }}</span>
                  <span class="final-price">¥{{ game.finalPrice || game.price }}</span>
                </div>
              </div>
              <div v-else class="free-tag">
                免费开玩
              </div>
            </div>

            <div v-if="!ownsGame" class="purchase-actions">
              <el-button type="primary" style="width: 100%" @click="handlePurchase">
                {{ game.price > 0 ? '立即购买' : '获取游戏' }}
              </el-button>
            </div>
            <div v-else class="owned-tag">
              <el-tag type="success" size="large">已在库中</el-tag>
            </div>

            <div class="game-meta">
              <div v-if="game.developer" class="meta-item">
                <span class="meta-label">开发商:</span>
                <span class="meta-value" @click="goToDeveloper">{{ game.developer }}</span>
              </div>
              <div v-if="game.publisher" class="meta-item">
                <span class="meta-label">发行商:</span>
                <span class="meta-value" @click="goToPublisher">{{ game.publisher }}</span>
              </div>
              <div v-if="game.releaseDate" class="meta-item">
                <span class="meta-label">发行日期:</span>
                <span class="meta-value static">{{ game.releaseDate }}</span>
              </div>
              <div v-if="gameCategories.length > 0" class="meta-item">
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

    <div v-else-if="loading" class="loading">
      <el-icon class="is-loading"><Loading /></el-icon>
      <span>加载中...</span>
    </div>
    <div v-else class="loading">
      <span>{{ loadError || '游戏详情加载失败' }}</span>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getGameById } from '@/api/game'
import {
  checkOwnership,
  createOrder,
  createReview,
  deleteReview,
  getGameReviews,
  getGameReviewSummary,
  getMyGameReview
} from '@/api'
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
const myReview = ref(null)
const gameImages = ref([])
const loading = ref(true)
const loadError = ref('')
const submittingReview = ref(false)
const deletingReview = ref(false)
const reviewSummary = ref({
  positiveReviews: 0,
  negativeReviews: 0,
  totalReviews: 0,
  positiveRate: 0
})
const reviewForm = ref({
  isPositive: 1,
  content: ''
})

const gameCategories = computed(() => {
  if (!game.value?.category) return []
  return String(game.value.category)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
})

const syncReviewForm = () => {
  reviewForm.value = {
    isPositive: myReview.value?.isPositive ?? 1,
    content: myReview.value?.content ?? ''
  }
}

const loadGame = async () => {
  loading.value = true
  loadError.value = ''
  try {
    game.value = await getGameById(route.params.id)
    if (game.value.images) {
      try {
        gameImages.value = JSON.parse(game.value.images) || []
      } catch {
        gameImages.value = []
      }
    } else {
      gameImages.value = []
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
  const res = await getGameReviews(route.params.id, { page: 0, size: 20 })
  reviews.value = res.content || []
}

const loadReviewSummary = async () => {
  reviewSummary.value = await getGameReviewSummary(route.params.id)
}

const checkOwnershipStatus = async () => {
  if (!userStore.isLoggedIn) {
    ownsGame.value = false
    return
  }

  try {
    ownsGame.value = await checkOwnership(route.params.id)
  } catch {
    ownsGame.value = false
  }
}

const loadMyReview = async () => {
  if (!userStore.isLoggedIn || !ownsGame.value) {
    myReview.value = null
    syncReviewForm()
    return
  }

  try {
    myReview.value = await getMyGameReview(route.params.id)
  } catch {
    myReview.value = null
  } finally {
    syncReviewForm()
  }
}

const refreshReviewArea = async () => {
  await Promise.all([loadGame(), loadReviewSummary(), loadReviews(), loadMyReview()])
}

const handleSubmitReview = async () => {
  if (!userStore.isLoggedIn) {
    router.push('/login')
    return
  }
  if (!ownsGame.value) {
    ElMessage.error('只有游戏库中拥有该游戏的用户才可以评论')
    return
  }

  submittingReview.value = true
  try {
    await createReview({
      gameId: route.params.id,
      isPositive: reviewForm.value.isPositive,
      content: reviewForm.value.content
    })
    ElMessage.success(myReview.value?.id ? '评论已更新' : '评论已发布')
    await refreshReviewArea()
  } finally {
    submittingReview.value = false
  }
}

const handleDeleteReview = async () => {
  if (!myReview.value?.id) return

  try {
    await ElMessageBox.confirm('确定删除这条评论吗？', '提示', {
      type: 'warning'
    })
    deletingReview.value = true
    await deleteReview(myReview.value.id)
    ElMessage.success('评论已删除')
    myReview.value = null
    syncReviewForm()
    await Promise.all([loadGame(), loadReviewSummary(), loadReviews()])
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error?.message || '删除评论失败')
    }
  } finally {
    deletingReview.value = false
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
    ElMessage.success(`购买成功，激活码：${order.activationCode}`)
    await checkOwnershipStatus()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

const goToDeveloper = () => {
  if (game.value?.developer) {
    router.push(`/developer/${game.value.developer}`)
  }
}

const goToPublisher = () => {
  if (game.value?.publisher) {
    router.push({ path: '/search', query: { publisher: game.value.publisher } })
  }
}

const goToCategory = (categoryName) => {
  if (categoryName) {
    router.push(`/category/${categoryName}`)
  }
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

const initializePage = async () => {
  await loadGame()
  await loadReviewSummary()
  await loadReviews()
  await checkOwnershipStatus()
  await loadMyReview()
}

watch(
  () => route.params.id,
  () => {
    initializePage()
  }
)

watch(
  () => userStore.isLoggedIn,
  async () => {
    await checkOwnershipStatus()
    await loadMyReview()
  }
)

onMounted(() => {
  initializePage()
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
}

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
}

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

.game-description,
.system-requirements,
.reviews-section {
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.2);
  padding: 20px;
  border-radius: 3px;
  margin-bottom: 20px;
}

.game-description h3,
.system-requirements h3,
.reviews-section h3 {
  color: #ffffff;
  margin-bottom: 10px;
}

.game-description p,
.system-requirements pre {
  color: #c7d5e0;
  line-height: 1.6;
  white-space: pre-wrap;
  font-family: inherit;
}

.reviews-header {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.reviews-header p {
  color: #8fa7bf;
  margin: 0;
}

.review-summary {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 20px;
}

.review-stat,
.review-rate,
.review-total {
  padding: 16px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.04);
  display: flex;
  flex-direction: column;
  gap: 6px;
  color: #c7d5e0;
}

.review-stat .positive,
.review-rate strong,
.review-total strong {
  color: #66c0f4;
  font-size: 28px;
  font-weight: 700;
}

.review-stat .negative {
  color: #ff6b6b;
  font-size: 28px;
  font-weight: 700;
}

.review-editor {
  margin-bottom: 24px;
  padding: 18px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.04);
}

.review-editor p,
.review-editor h4 {
  color: #fff;
  margin: 0 0 14px;
}

.review-radio-group {
  margin-bottom: 14px;
}

.steam-vote-card {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  min-width: 220px;
  text-align: left;
}

.vote-badge {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  line-height: 1;
  background: rgba(255, 255, 255, 0.06);
}

.vote-copy {
  display: flex;
  flex-direction: column;
  gap: 2px;

  strong {
    font-size: 14px;
    line-height: 1.2;
  }

  small {
    color: #8fa7bf;
    font-size: 12px;
    line-height: 1.2;
  }
}

.positive-card {
  color: #a4d007;
}

.positive-card .vote-badge {
  background: linear-gradient(180deg, rgba(114, 176, 36, 0.95) 0%, rgba(76, 107, 34, 0.95) 100%);
}

.negative-card {
  color: #ff8b8b;
}

.negative-card .vote-badge {
  background: linear-gradient(180deg, rgba(170, 56, 56, 0.95) 0%, rgba(116, 34, 34, 0.95) 100%);
}

.review-textarea {
  :deep(.el-textarea__inner) {
    background: linear-gradient(180deg, rgba(18, 30, 42, 0.98) 0%, rgba(14, 23, 33, 0.98) 100%);
    border: 1px solid rgba(102, 192, 244, 0.18);
    color: #d7e5f0;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.03);
  }

  :deep(.el-textarea__inner:focus) {
    border-color: rgba(102, 192, 244, 0.5);
    box-shadow: 0 0 0 1px rgba(102, 192, 244, 0.15);
  }

  :deep(.el-input__count) {
    background: transparent;
    color: #8fa7bf;
  }
}

.review-radio-group {
  :deep(.el-radio-button__inner) {
    padding: 12px 16px;
    background: linear-gradient(180deg, rgba(24, 39, 54, 0.98) 0%, rgba(18, 30, 42, 0.98) 100%);
    border-color: rgba(255, 255, 255, 0.06);
    color: #c7d5e0;
    min-width: 252px;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.03);
  }

  :deep(.el-radio-button:first-child .el-radio-button__inner) {
    border-left-color: rgba(255, 255, 255, 0.06);
  }

  :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
    background: linear-gradient(180deg, rgba(46, 74, 99, 0.98) 0%, rgba(30, 53, 74, 0.98) 100%);
    border-color: rgba(102, 192, 244, 0.42);
    box-shadow: 0 0 0 1px rgba(102, 192, 244, 0.16), inset 0 1px 0 rgba(255, 255, 255, 0.06);
  }

  :deep(.el-radio-button__inner:hover) {
    color: #ffffff;
    border-color: rgba(102, 192, 244, 0.22);
  }
}

.review-editor-actions {
  display: flex;
  gap: 12px;
  margin-top: 14px;
}

.empty-reviews {
  padding: 20px 0;
  color: #8fa7bf;
}

.review-item {
  padding: 18px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.review-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}

.review-user {
  display: flex;
  align-items: center;
  gap: 12px;
}

.review-avatar {
  width: 42px;
  height: 42px;
  border-radius: 50%;
  object-fit: cover;
}

.review-avatar.placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(102, 192, 244, 0.22);
  color: #fff;
  font-weight: 700;
}

.review-username {
  color: #fff;
  font-weight: 600;
}

.review-time {
  color: #8b929a;
  font-size: 12px;
}

.review-type {
  padding: 5px 10px;
  border-radius: 999px;
  font-size: 12px;
  color: #fff;
}

.review-type.positive {
  background: linear-gradient(180deg, #7bb43c 0%, #4c6b22 100%);
}

.review-type.negative {
  background: linear-gradient(180deg, #c55f5f 0%, #7e2f2f 100%);
}

.review-content {
  color: #c7d5e0;
  line-height: 1.7;
}

.review-content.empty {
  color: #8fa7bf;
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
}

.purchase-cover {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
  margin-bottom: 20px;
}

.purchase-info {
  margin-bottom: 20px;
}

.price-section {
  display: flex;
  align-items: center;
  gap: 10px;
}

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
}

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

.free-tag {
  background: #4c6b22;
  color: #a4d007;
  padding: 10px;
  text-align: center;
  border-radius: 4px;
  font-size: 18px;
  font-weight: bold;
}

.owned-tag {
  text-align: center;
  margin: 20px 0;
}

.game-meta {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.meta-item {
  display: flex;
  margin-bottom: 10px;
  font-size: 13px;
}

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

.meta-value.static {
  cursor: default;

  &:hover {
    text-decoration: none;
  }
}

.meta-categories {
  display: flex;
  flex-wrap: wrap;
}

.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 400px;
  color: #ffffff;
  gap: 20px;
}

.loading .is-loading {
  font-size: 48px;
}

@media (max-width: 960px) {
  .detail-container {
    grid-template-columns: 1fr;
  }

  .sidebar-section,
  .purchase-card {
    position: static;
  }

  .review-summary {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 640px) {
  .review-radio-group {
    :deep(.el-radio-button__inner) {
      min-width: 100%;
    }

    :deep(.el-radio-button) {
      display: block;
      margin-bottom: 10px;
    }
  }

  .steam-vote-card {
    min-width: 0;
    width: 100%;
  }

  .review-summary {
    grid-template-columns: 1fr;
  }

  .review-header-row {
    flex-direction: column;
    align-items: flex-start;
  }

  .review-editor-actions {
    flex-direction: column;
  }
}
</style>
