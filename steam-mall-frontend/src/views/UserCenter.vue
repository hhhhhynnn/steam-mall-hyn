<template>
  <div class="user-center">
    <Navbar />
    
    <div class="user-content">
      <div class="user-sidebar">
        <div class="user-profile">
          <el-avatar :size="80">{{ userStore.username[0].toUpperCase() }}</el-avatar>
          <h3>{{ userStore.username }}</h3>
          <el-tag :type="userStore.role === 'ADMIN' ? 'danger' : 'primary'">
            {{ userStore.role === 'ADMIN' ? '管理员' : '普通用户' }}
          </el-tag>
        </div>

        <el-menu :default-active="activeMenu" class="user-menu" @select="handleMenuSelect">
          <el-menu-item index="profile">
            <el-icon><User /></el-icon>
            <span>个人资料</span>
          </el-menu-item>
          <el-menu-item index="library">
            <el-icon><VideoPlay /></el-icon>
            <span>我的游戏库</span>
          </el-menu-item>
          <el-menu-item index="orders">
            <el-icon><Document /></el-icon>
            <span>订单管理</span>
          </el-menu-item>
        </el-menu>
      </div>

      <div class="user-main">
        <div class="welcome-card">
          <h2>欢迎来到您的个人中心</h2>
          <p>在这里您可以管理您的游戏库、查看订单历史和编写评价</p>
          
          <div class="stats">
            <div class="stat-item">
              <div class="stat-value">{{ libraryCount }}</div>
              <div class="stat-label">已拥有游戏</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ orderCount }}</div>
              <div class="stat-label">订单数量</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ reviewCount }}</div>
              <div class="stat-label">发表评价</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { getUserGames, getUserOrders } from '@/api'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()
const userStore = useUserStore()

const activeMenu = ref('profile')
const libraryCount = ref(0)
const orderCount = ref(0)
const reviewCount = ref(0)

const handleMenuSelect = (index) => {
  if (index === 'library') {
    router.push('/user/library')
  } else if (index === 'orders') {
    router.push('/user/orders')
  }
}

const loadStats = async () => {
  try {
    const libraryRes = await getUserGames()
    libraryCount.value = libraryRes.length || 0
  } catch (error) {
    console.error(error)
  }

  try {
    const ordersRes = await getUserOrders({ page: 0, size: 1 })
    orderCount.value = ordersRes.totalElements || 0
  } catch (error) {
    console.error(error)
  }

  reviewCount.value = 0
}

onMounted(() => {
  loadStats()
})
</script>

<style scoped lang="scss">
.user-center {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.user-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 30px;
}

.user-sidebar {
  .user-profile {
    background: rgba(0, 0, 0, 0.3);
    padding: 30px;
    border-radius: 8px;
    text-align: center;
    margin-bottom: 20px;

    h3 {
      color: #ffffff;
      margin: 15px 0 10px;
      font-size: 18px;
    }
  }

  .user-menu {
    background: rgba(0, 0, 0, 0.2);
    border-radius: 8px;
    
    :deep(.el-menu-item) {
      color: #c7d5e0;
      
      &:hover {
        background: rgba(102, 192, 244, 0.2);
      }
      
      &.is-active {
        background: rgba(102, 192, 244, 0.3);
        color: #66c0f4;
      }
    }
  }
}

.user-main {
  .welcome-card {
    background: rgba(0, 0, 0, 0.3);
    padding: 40px;
    border-radius: 8px;

    h2 {
      color: #ffffff;
      margin-bottom: 10px;
    }

    p {
      color: #8b929a;
      margin-bottom: 30px;
    }
  }

  .stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-top: 30px;

    .stat-item {
      background: rgba(0, 0, 0, 0.2);
      padding: 20px;
      border-radius: 8px;
      text-align: center;

      .stat-value {
        color: #66c0f4;
        font-size: 36px;
        font-weight: bold;
        margin-bottom: 5px;
      }

      .stat-label {
        color: #8b929a;
        font-size: 14px;
      }
    }
  }
}
</style>
