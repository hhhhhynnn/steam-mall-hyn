<template>
  <div class="user-cart">
    <Navbar />

    <div class="cart-hero">
      <div class="hero-copy">
        <span class="eyebrow">YOUR CART</span>
        <h1>我的购物车</h1>
      </div>
      <div class="hero-stats">
        <div class="stat-card">
          <span>购物车商品</span>
          <strong>{{ items.length }}</strong>
        </div>
        <div class="stat-card">
          <span>已选商品</span>
          <strong>{{ selectedIds.length }}</strong>
        </div>
        <div class="stat-card accent">
          <span>合计</span>
          <strong>¥{{ selectedAmount }}</strong>
        </div>
      </div>
    </div>

    <div class="cart-layout">
      <section class="cart-main">
        <div class="cart-toolbar" v-if="items.length">
          <el-checkbox
            :model-value="allSelectableChecked"
            :indeterminate="indeterminate"
            @change="toggleSelectAll"
          >
            全选可购买商品
          </el-checkbox>
        </div>

        <div v-if="loading" class="state-panel">正在加载购物车...</div>

        <template v-else-if="items.length">
          <article
            v-for="item in items"
            :key="item.id"
            class="cart-item"
            :class="{ disabled: !isSelectable(item) }"
          >
            <div class="select-box">
              <el-checkbox
                :model-value="selectedIds.includes(item.id)"
                :disabled="!isSelectable(item)"
                @change="value => toggleItem(item.id, value)"
              />
            </div>

            <img
              class="item-cover"
              :src="item.coverImage || item.bannerImage"
              :alt="item.gameName"
              @click="goToGame(item.gameId)"
            />

            <div class="item-content">
              <div class="item-top">
                <div>
                  <h3 class="item-title" @click="goToGame(item.gameId)">{{ item.gameName }}</h3>
                  <div class="item-meta">
                    <span v-if="item.developer">{{ item.developer }}</span>
                    <span v-if="item.category">{{ item.category }}</span>
                    <span>{{ formatDate(item.createdAt) }} 加入</span>
                  </div>
                </div>
                <el-button text type="danger" @click="handleRemove(item.id)">移除</el-button>
              </div>

              <div class="item-bottom">
                <div class="price-block">
                  <span v-if="item.originalPrice && item.originalPrice !== displayPrice(item)" class="original-price">
                    ¥{{ item.originalPrice }}
                  </span>
                  <strong>¥{{ displayPrice(item) }}</strong>
                  <span class="price-note">当前价</span>
                </div>

                <div class="status-tags">
                  <el-tag v-if="item.owned" type="success">已在库中</el-tag>
                  <el-tag v-else-if="item.status !== 1" type="danger">已下架</el-tag>
                  <el-tag v-else type="info">可购买</el-tag>
                </div>
              </div>
            </div>
          </article>
        </template>

        <div v-else class="empty-panel">
          <el-empty description="购物车还是空的">
            <el-button type="primary" @click="router.push('/')">去商城逛逛</el-button>
          </el-empty>
        </div>
      </section>

      <aside class="summary-panel">
        <div class="summary-card">
          <span class="summary-label">将要购买</span>
          <strong class="summary-total">¥{{ selectedAmount }}</strong>
          <p>共 {{ selectedIds.length }} 款游戏</p>
          <el-button
            type="primary"
            size="large"
            :disabled="selectedIds.length === 0"
            :loading="submitting"
            @click="handleCheckout"
          >
            购买所选游戏
          </el-button>
          <el-button plain size="large" :disabled="selectedIds.length === 0" @click="clearSelection">
            取消选择
          </el-button>
        </div>
      </aside>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { createBatchOrders, getCart, removeFromCart } from '@/api'
import { ElMessage, ElMessageBox } from 'element-plus'
import Navbar from '@/components/Navbar.vue'
import dayjs from 'dayjs'

const router = useRouter()
const items = ref([])
const selectedIds = ref([])
const loading = ref(false)
const submitting = ref(false)

const selectableIds = computed(() =>
  items.value.filter(item => isSelectable(item)).map(item => item.id)
)

const allSelectableChecked = computed(() =>
  selectableIds.value.length > 0 && selectedIds.value.length === selectableIds.value.length
)

const indeterminate = computed(() =>
  selectedIds.value.length > 0 && selectedIds.value.length < selectableIds.value.length
)

const selectedAmount = computed(() => {
  const selectedSet = new Set(selectedIds.value)
  return items.value
    .filter(item => selectedSet.has(item.id))
    .reduce((sum, item) => sum + Number(displayPrice(item) || 0), 0)
    .toFixed(2)
})

const isSelectable = (item) => item.status === 1 && !item.owned

const displayPrice = (item) => item.currentPrice ?? item.price

const normalizeSelection = () => {
  const available = new Set(selectableIds.value)
  selectedIds.value = selectedIds.value.filter(id => available.has(id))
}

const loadCart = async () => {
  loading.value = true
  try {
    const res = await getCart()
    items.value = res.items || []
    normalizeSelection()
  } finally {
    loading.value = false
  }
}

const toggleSelectAll = (checked) => {
  selectedIds.value = checked ? [...selectableIds.value] : []
}

const toggleItem = (id, checked) => {
  if (checked) {
    if (!selectedIds.value.includes(id)) {
      selectedIds.value = [...selectedIds.value, id]
    }
    return
  }
  selectedIds.value = selectedIds.value.filter(itemId => itemId !== id)
}

const clearSelection = () => {
  selectedIds.value = []
}

const handleRemove = async (cartItemId) => {
  await removeFromCart(cartItemId)
  ElMessage.success('已从购物车移除')
  window.dispatchEvent(new Event('cart-updated'))
  await loadCart()
}

const handleCheckout = async () => {
  if (selectedIds.value.length === 0) {
    ElMessage.warning('请选择要购买的游戏')
    return
  }

  try {
    await ElMessageBox.confirm(
      `确认购买选中的 ${selectedIds.value.length} 款游戏吗？`,
      '批量购买',
      { type: 'warning' }
    )

    submitting.value = true
    const orders = await createBatchOrders({ cartItemIds: selectedIds.value })
    ElMessage.success(`购买成功，已生成 ${orders.length} 个激活码`)
    selectedIds.value = []
    window.dispatchEvent(new Event('cart-updated'))
    await loadCart()
    router.push('/user/orders')
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  } finally {
    submitting.value = false
  }
}

const goToGame = (gameId) => {
  router.push(`/game/${gameId}`)
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm')

onMounted(() => {
  loadCart()
})
</script>

<style scoped lang="scss">
.user-cart {
  min-height: 100vh;
  background:
    radial-gradient(circle at top, rgba(84, 144, 197, 0.18) 0%, transparent 28%),
    linear-gradient(180deg, #101822 0%, #0f141b 100%);
}

.cart-hero,
.cart-layout {
  max-width: 1280px;
  margin: 0 auto;
  padding: 28px 20px;
}

.cart-hero {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: end;
}

.eyebrow {
  display: inline-block;
  color: #66c0f4;
  font-size: 12px;
  letter-spacing: 0.18em;
  margin-bottom: 10px;
}

.hero-copy h1 {
  margin: 0 0 10px;
  color: #fff;
  font-size: 40px;
}

.hero-copy p {
  margin: 0;
  color: #9cb3c9;
  max-width: 560px;
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(140px, 1fr));
  gap: 14px;
}

.stat-card {
  padding: 18px;
  border-radius: 14px;
  background: linear-gradient(180deg, rgba(30, 46, 62, 0.94) 0%, rgba(21, 32, 43, 0.94) 100%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: #8fa7bf;
}

.stat-card strong {
  display: block;
  margin-top: 8px;
  color: #fff;
  font-size: 30px;
}

.stat-card.accent {
  border-color: rgba(164, 208, 7, 0.34);
}

.stat-card.accent strong {
  color: #beee11;
}

.cart-layout {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 320px;
  gap: 24px;
  align-items: start;
}

.cart-toolbar,
.cart-item,
.summary-card,
.state-panel,
.empty-panel {
  background: linear-gradient(180deg, rgba(27, 40, 56, 0.96) 0%, rgba(18, 26, 37, 0.96) 100%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 18px 36px rgba(0, 0, 0, 0.22);
}

.cart-toolbar {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: center;
  border-radius: 14px;
  padding: 18px 20px;
  margin-bottom: 16px;
  color: #c7d5e0;
}

.toolbar-copy {
  color: #8fa7bf;
  font-size: 13px;
}

.cart-item {
  display: grid;
  grid-template-columns: 28px 220px minmax(0, 1fr);
  gap: 18px;
  padding: 18px;
  border-radius: 16px;
  margin-bottom: 16px;
}

.cart-item.disabled {
  opacity: 0.72;
}

.select-box {
  padding-top: 12px;
}

.item-cover {
  width: 100%;
  height: 104px;
  object-fit: cover;
  border-radius: 10px;
  cursor: pointer;
}

.item-content {
  min-width: 0;
}

.item-top,
.item-bottom {
  display: flex;
  justify-content: space-between;
  gap: 18px;
}

.item-top {
  margin-bottom: 28px;
}

.item-title {
  margin: 0 0 10px;
  font-size: 24px;
  color: #fff;
  cursor: pointer;
}

.item-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 16px;
  color: #8fa7bf;
  font-size: 13px;
}

.price-block {
  display: flex;
  align-items: baseline;
  gap: 10px;
}

.price-block strong {
  color: #beee11;
  font-size: 28px;
}

.original-price {
  color: #738895;
  text-decoration: line-through;
}

.price-note {
  color: #8fa7bf;
  font-size: 13px;
}

.summary-panel {
  position: sticky;
  top: 92px;
}

.summary-card {
  border-radius: 18px;
  padding: 24px;
}

.summary-label {
  color: #8fa7bf;
  font-size: 13px;
  letter-spacing: 0.12em;
}

.summary-total {
  display: block;
  color: #beee11;
  font-size: 38px;
  margin: 12px 0 6px;
}

.summary-card p {
  color: #c7d5e0;
  margin: 0 0 24px;
}

.summary-card :deep(.el-button) {
  width: 100%;
  margin-left: 0;
}

.summary-card :deep(.el-button + .el-button) {
  margin-top: 12px;
}

.state-panel,
.empty-panel {
  border-radius: 16px;
  padding: 48px 20px;
  color: #c7d5e0;
  text-align: center;
}

@media (max-width: 1100px) {
  .cart-layout {
    grid-template-columns: 1fr;
  }

  .summary-panel {
    position: static;
  }
}

@media (max-width: 860px) {
  .cart-hero {
    flex-direction: column;
    align-items: stretch;
  }

  .hero-stats {
    grid-template-columns: 1fr;
  }

  .cart-item {
    grid-template-columns: 28px 1fr;
  }

  .item-cover {
    grid-column: 2;
  }

  .item-content {
    grid-column: 1 / -1;
  }
}

@media (max-width: 640px) {
  .cart-toolbar,
  .item-top,
  .item-bottom {
    flex-direction: column;
    align-items: flex-start;
  }

  .hero-copy h1 {
    font-size: 32px;
  }
}
</style>
