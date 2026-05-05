<template>
  <div class="user-orders">
    <Navbar />

    <div class="orders-shell">
      <section class="orders-hero">
        <div>
          <span class="eyebrow">PURCHASE HISTORY</span>
          <h1>订单管理</h1>
        </div>
        <div class="hero-metrics">
          <div class="metric-card">
            <span>订单总数</span>
            <strong>{{ total }}</strong>
          </div>
          <div class="metric-card accent">
            <span>已支付</span>
            <strong>{{ paidCount }}</strong>
          </div>
        </div>
      </section>

      <section class="orders-panel">
        <div v-if="loading" class="state-panel">正在加载订单...</div>

        <template v-else-if="orders.length">
          <article v-for="order in orders" :key="order.orderNo" class="order-card">
            <div class="order-main">
              <div class="order-head">
                <div>
                  <h3>{{ order.gameName }}</h3>
                  <div class="order-meta">
                    <span>订单号 {{ order.orderNo }}</span>
                    <span>{{ formatDate(order.createdAt) }}</span>
                  </div>
                </div>
                <el-tag :type="order.paymentStatus === 1 ? 'success' : 'warning'" size="large">
                  {{ order.paymentStatus === 1 ? '已支付' : '待支付' }}
                </el-tag>
              </div>

              <div class="order-body">
                <div class="order-amount">
                  <span>成交金额</span>
                  <strong>¥{{ order.amount }}</strong>
                </div>

                <div class="activation-box">
                  <span>激活码</span>
                  <strong>{{ order.activationCode || '付款后生成' }}</strong>
                </div>
              </div>
            </div>

            <div class="order-actions">
              <el-button
                v-if="order.paymentStatus === 0"
                type="primary"
                size="small"
                @click="handlePay(order)"
              >
                支付
              </el-button>
              <el-button
                v-if="order.activationCode"
                type="success"
                size="small"
                @click="copyActivationCode(order.activationCode)"
              >
                复制激活码
              </el-button>
            </div>
          </article>
        </template>

        <div v-else class="empty-panel">
          <el-empty description="暂无订单">
            <el-button type="primary" @click="goToStore">去商城逛逛</el-button>
          </el-empty>
        </div>
      </section>

      <div class="pagination" v-if="total > 0">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="loadOrders"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { getUserOrders, payOrder } from '@/api'
import { ElMessage } from 'element-plus'
import Navbar from '@/components/Navbar.vue'
import dayjs from 'dayjs'

const router = useRouter()

const orders = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const loading = ref(false)

const paidCount = computed(() => orders.value.filter(order => order.paymentStatus === 1).length)

const loadOrders = async () => {
  loading.value = true
  try {
    const res = await getUserOrders({
      page: currentPage.value - 1,
      size: pageSize.value
    })
    orders.value = res.content || []
    total.value = res.totalElements || 0
  } finally {
    loading.value = false
  }
}

const handlePay = async (order) => {
  await payOrder(order.orderNo)
  ElMessage.success('支付成功')
  await loadOrders()
}

const copyActivationCode = async (code) => {
  await navigator.clipboard.writeText(code)
  ElMessage.success('激活码已复制到剪贴板')
}

const formatDate = (date) => dayjs(date).format('YYYY-MM-DD HH:mm:ss')

const goToStore = () => {
  router.push('/')
}

onMounted(() => {
  loadOrders()
})
</script>

<style scoped lang="scss">
.user-orders {
  min-height: 100vh;
  background:
    radial-gradient(circle at top, rgba(102, 192, 244, 0.16) 0%, transparent 32%),
    linear-gradient(180deg, #101822 0%, #0f141b 100%);
}

.orders-shell {
  max-width: 1240px;
  margin: 0 auto;
  padding: 28px 20px 44px;
}

.orders-hero {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: end;
  margin-bottom: 26px;
}

.eyebrow {
  display: inline-block;
  color: #66c0f4;
  font-size: 12px;
  letter-spacing: 0.18em;
  margin-bottom: 10px;
}

.orders-hero h1 {
  margin: 0 0 8px;
  color: #fff;
  font-size: 38px;
}

.orders-hero p {
  margin: 0;
  color: #9cb3c9;
}

.hero-metrics {
  display: grid;
  grid-template-columns: repeat(2, minmax(160px, 1fr));
  gap: 14px;
}

.metric-card {
  padding: 18px 20px;
  border-radius: 14px;
  background: linear-gradient(180deg, rgba(30, 46, 62, 0.94) 0%, rgba(21, 32, 43, 0.94) 100%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: #8fa7bf;
}

.metric-card strong {
  display: block;
  margin-top: 8px;
  color: #fff;
  font-size: 30px;
}

.metric-card.accent strong {
  color: #beee11;
}

.orders-panel {
  display: grid;
  gap: 16px;
}

.order-card,
.state-panel,
.empty-panel {
  background: linear-gradient(180deg, rgba(27, 40, 56, 0.96) 0%, rgba(18, 26, 37, 0.96) 100%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 0 18px 36px rgba(0, 0, 0, 0.22);
}

.order-card {
  border-radius: 16px;
  padding: 20px 22px;
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: center;
}

.order-main {
  min-width: 0;
  flex: 1;
}

.order-head,
.order-body {
  display: flex;
  justify-content: space-between;
  gap: 18px;
  align-items: center;
}

.order-head {
  margin-bottom: 18px;
}

.order-head h3 {
  margin: 0 0 8px;
  color: #fff;
  font-size: 24px;
}

.order-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 16px;
  color: #8fa7bf;
  font-size: 13px;
}

.order-amount,
.activation-box {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.order-amount span,
.activation-box span {
  color: #8fa7bf;
  font-size: 12px;
  letter-spacing: 0.08em;
}

.order-amount strong {
  color: #beee11;
  font-size: 30px;
}

.activation-box strong {
  color: #e8f3ff;
  font-size: 16px;
  word-break: break-all;
}

.order-actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.state-panel,
.empty-panel {
  border-radius: 16px;
  padding: 50px 20px;
  color: #c7d5e0;
  text-align: center;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 28px;
}

@media (max-width: 960px) {
  .orders-hero,
  .order-card,
  .order-head,
  .order-body {
    flex-direction: column;
    align-items: flex-start;
  }

  .hero-metrics {
    width: 100%;
    grid-template-columns: 1fr 1fr;
  }

  .order-actions {
    width: 100%;
    flex-direction: row;
  }
}

@media (max-width: 640px) {
  .orders-hero h1 {
    font-size: 30px;
  }

  .hero-metrics {
    grid-template-columns: 1fr;
  }

  .order-actions {
    flex-direction: column;
  }
}
</style>
