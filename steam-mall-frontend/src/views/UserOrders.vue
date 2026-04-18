<template>
  <div class="user-orders">
    <Navbar />
    
    <div class="orders-content">
      <h2>订单管理</h2>
      
      <el-table :data="orders" style="width: 100%" v-loading="loading">
        <el-table-column prop="orderNo" label="订单号" />
        <el-table-column prop="gameName" label="游戏名称" />
        <el-table-column prop="amount" label="金额">
          <template #default="{ row }">
            ¥{{ row.amount }}
          </template>
        </el-table-column>
        <el-table-column prop="paymentStatus" label="状态">
          <template #default="{ row }">
            <el-tag :type="row.paymentStatus === 1 ? 'success' : 'warning'">
              {{ row.paymentStatus === 1 ? '已支付' : '未支付' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="activationCode" label="激活码" />
        <el-table-column prop="createdAt" label="创建时间">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button 
              v-if="row.paymentStatus === 0" 
              type="primary" 
              size="small"
              @click="handlePay(row)"
            >
              支付
            </el-button>
            <el-button 
              v-if="row.activationCode" 
              type="success" 
              size="small"
              @click="copyActivationCode(row.activationCode)"
            >
              复制激活码
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination" v-if="total > 0">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="loadOrders"
        />
      </div>

      <div class="no-orders" v-if="orders.length === 0 && !loading">
        <el-empty description="暂无订单">
          <el-button type="primary" @click="goToStore">去商店逛逛</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
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

const loadOrders = async () => {
  loading.value = true
  try {
    const res = await getUserOrders({
      page: currentPage.value - 1,
      size: pageSize.value
    })
    orders.value = res.content || []
    total.value = res.totalElements || 0
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handlePay = async (order) => {
  try {
    await payOrder(order.orderNo)
    ElMessage.success('支付成功')
    loadOrders()
  } catch (error) {
    console.error(error)
  }
}

const copyActivationCode = (code) => {
  navigator.clipboard.writeText(code)
  ElMessage.success('激活码已复制到剪贴板')
}

const formatDate = (date) => {
  return dayjs(date).format('YYYY-MM-DD HH:mm:ss')
}

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
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.orders-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;

  h2 {
    color: #ffffff;
    margin-bottom: 30px;
  }
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

.no-orders {
  padding: 60px 0;
  text-align: center;
}
</style>
