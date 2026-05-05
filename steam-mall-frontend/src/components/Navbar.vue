<template>
  <div class="navbar">
    <div class="navbar-content">
      <div class="logo" @click="goHome">
        <span>STEAM 商城</span>
      </div>

      <div class="nav-links">
        <router-link to="/">商店首页</router-link>
        <router-link v-if="userStore.isLoggedIn" to="/user/cart" class="cart-link">
          我的购物车
          <span v-if="cartCount > 0" class="cart-badge">{{ cartCount }}</span>
        </router-link>
        <router-link v-if="userStore.isLoggedIn" to="/user/orders">订单管理</router-link>
        <a href="#" @click.prevent>社区</a>
        <a href="#" @click.prevent>关于</a>
      </div>

      <div class="user-actions">
        <template v-if="userStore.isLoggedIn">
          <el-dropdown>
            <span class="user-info">
              <el-avatar :size="32" :src="userStore.avatar">
                {{ userStore.username[0]?.toUpperCase() }}
              </el-avatar>
              <span class="username">{{ userStore.username }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goToUserCenter">个人中心</el-dropdown-item>
                <el-dropdown-item @click="goToLibrary">我的游戏库</el-dropdown-item>
                <el-dropdown-item @click="goToCart">我的购物车</el-dropdown-item>
                <el-dropdown-item @click="goToOrders">订单管理</el-dropdown-item>
                <el-dropdown-item v-if="userStore.role === 'ADMIN'" @click="goToAdmin">管理后台</el-dropdown-item>
                <el-dropdown-item divided @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
        <template v-else>
          <el-button type="primary" @click="goToLogin">登录</el-button>
          <el-button @click="goToRegister">注册</el-button>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { getCartCount } from '@/api'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()
const cartCount = ref(0)

const loadCartCount = async () => {
  if (!userStore.isLoggedIn) {
    cartCount.value = 0
    return
  }

  try {
    const res = await getCartCount()
    cartCount.value = res.count || 0
  } catch {
    cartCount.value = 0
  }
}

const handleCartUpdate = () => {
  loadCartCount()
}

const goHome = () => {
  router.push('/')
}

const goToLogin = () => {
  router.push('/login')
}

const goToRegister = () => {
  router.push('/register')
}

const goToUserCenter = () => {
  router.push('/user')
}

const goToLibrary = () => {
  router.push('/user/library')
}

const goToCart = () => {
  router.push('/user/cart')
}

const goToOrders = () => {
  router.push('/user/orders')
}

const goToAdmin = () => {
  router.push('/admin')
}

const handleLogout = () => {
  userStore.logout()
  cartCount.value = 0
  ElMessage.success('已退出登录')
  router.push('/')
}

watch(
  () => userStore.isLoggedIn,
  () => {
    loadCartCount()
  },
  { immediate: true }
)

onMounted(() => {
  window.addEventListener('cart-updated', handleCartUpdate)
})

onUnmounted(() => {
  window.removeEventListener('cart-updated', handleCartUpdate)
})
</script>

<style scoped lang="scss">
.navbar {
  background:
    linear-gradient(180deg, rgba(23, 26, 33, 0.98) 0%, rgba(16, 22, 31, 0.98) 100%);
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.32);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.navbar-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  min-height: 68px;
}

.logo {
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  cursor: pointer;
  letter-spacing: 1px;
  white-space: nowrap;
  transition: color 0.25s;

  &:hover {
    color: #66c0f4;
  }
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 26px;
  flex: 1;
  justify-content: center;
  flex-wrap: wrap;

  a {
    color: #d6e1ea;
    text-decoration: none;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: color 0.3s;
  }

  a:hover,
  .router-link-active {
    color: #66c0f4;
  }
}

.cart-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.cart-badge {
  min-width: 20px;
  height: 20px;
  padding: 0 6px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(180deg, #8ac926 0%, #5f8618 100%);
  color: #10161f;
  font-size: 12px;
  font-weight: 700;
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.username {
  color: #ffffff;
  font-size: 14px;
}

@media (max-width: 860px) {
  .navbar-content {
    padding: 10px 16px;
    min-height: 0;
    flex-wrap: wrap;
  }

  .nav-links {
    order: 3;
    width: 100%;
    justify-content: flex-start;
    gap: 18px;
    padding-bottom: 8px;
  }
}
</style>
