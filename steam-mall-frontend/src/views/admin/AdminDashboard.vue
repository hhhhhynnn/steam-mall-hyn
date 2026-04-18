<template>
  <div class="admin-dashboard">
    <div class="admin-header">
      <h1>管理后台</h1>
      <div class="header-actions">
        <el-button type="primary" @click="goToGameManagement">游戏管理</el-button>
        <el-button @click="goBack">返回前台</el-button>
      </div>
    </div>

    <div class="admin-content">
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon" style="background: #409EFF">
              <el-icon><VideoPlay /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalGames }}</div>
              <div class="stat-label">游戏总数</div>
            </div>
          </div>
        </el-col>

        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon" style="background: #67C23A">
              <el-icon><ShoppingCart /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalSales }}</div>
              <div class="stat-label">总销量</div>
            </div>
          </div>
        </el-col>

        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon" style="background: #E6A23C">
              <el-icon><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalUsers }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </div>
        </el-col>

        <el-col :span="6">
          <div class="stat-card">
            <div class="stat-icon" style="background: #F56C6C">
              <el-icon><Money /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥{{ stats.totalRevenue }}</div>
              <div class="stat-label">总收入</div>
            </div>
          </div>
        </el-col>
      </el-row>

      <el-row :gutter="20" style="margin-top: 30px">
        <el-col :span="12">
          <div class="chart-card">
            <h3>游戏类型分布</h3>
            <div ref="categoryChart" class="chart"></div>
          </div>
        </el-col>

        <el-col :span="12">
          <div class="chart-card">
            <h3>销量统计</h3>
            <div ref="salesChart" class="chart"></div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import * as echarts from 'echarts'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const stats = ref({
  totalGames: 0,
  totalSales: 0,
  totalUsers: 0,
  totalRevenue: 0
})

const categoryChart = ref(null)
const salesChart = ref(null)
const categoryChartData = ref([])
const weeklySalesData = ref([])

const loadStats = async () => {
  try {
    const res = await fetch('/api/admin/dashboard/statistics', {
      headers: {
        Authorization: `Bearer ${userStore.token}`
      }
    })
    const data = await res.json()
    if (data.code !== 200) {
      throw new Error(data.message || '加载统计数据失败')
    }

    stats.value = {
      totalGames: data.data.totalGames || 0,
      totalSales: data.data.totalSales || 0,
      totalUsers: data.data.totalUsers || 0,
      totalRevenue: data.data.totalRevenue || 0
    }
    categoryChartData.value = data.data.categoryDistribution || []
    weeklySalesData.value = data.data.weeklySalesAmount || []
  } catch (error) {
    ElMessage.error(error.message || '加载统计数据失败')
  }
}

const initCategoryChart = () => {
  if (!categoryChart.value) return
  
  const chart = echarts.init(categoryChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'item'
    },
    series: [
      {
        name: '游戏类型',
        type: 'pie',
        radius: '50%',
        data: [
          ...categoryChartData.value
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  })
}

const initSalesChart = () => {
  if (!salesChart.value) return
  
  const chart = echarts.init(salesChart.value)
  chart.setOption({
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: weeklySalesData.value.map(item => item.day),
      axisLabel: {
        color: '#c7d5e0'
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        color: '#c7d5e0'
      }
    },
    series: [
      {
        name: '销售额',
        type: 'bar',
        data: weeklySalesData.value.map(item => item.amount),
        itemStyle: {
          color: '#66c0f4'
        }
      }
    ]
  })
}

const goBack = () => {
  router.push('/')
}

const goToGameManagement = () => {
  router.push('/admin/games')
}

onMounted(async () => {
  await loadStats()
  setTimeout(() => {
    initCategoryChart()
    initSalesChart()
  }, 100)

  window.addEventListener('resize', () => {
    if (categoryChart.value) {
      echarts.getInstanceByDom(categoryChart.value).resize()
    }
    if (salesChart.value) {
      echarts.getInstanceByDom(salesChart.value).resize()
    }
  })
})
</script>

<style scoped lang="scss">
.admin-dashboard {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
  padding: 20px;
}

.admin-header {
  max-width: 1400px;
  margin: 0 auto 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .header-actions {
    display: flex;
    gap: 10px;
  }

  h1 {
    color: #ffffff;
    font-size: 28px;
  }
}

.admin-content {
  max-width: 1400px;
  margin: 0 auto;
}

.stat-card {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 20px;

  .stat-icon {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    color: #fff;
  }

  .stat-info {
    flex: 1;

    .stat-value {
      color: #ffffff;
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .stat-label {
      color: #8b929a;
      font-size: 14px;
    }
  }
}

.chart-card {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  padding: 20px;

  h3 {
    color: #ffffff;
    margin-bottom: 20px;
  }

  .chart {
    height: 300px;
  }
}
</style>
