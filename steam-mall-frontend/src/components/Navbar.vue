<template>
  <div class="navbar">
    <div class="navbar-content">
      <div class="logo" @click="goHome">
        <span>STEAM 商城</span>
      </div>

      <div class="nav-links">
        <router-link to="/">商店首页</router-link>
        <a href="#" @click.prevent>社区</a>
        <a href="#" @click.prevent>关于</a>
        <a href="#" @click.prevent>客服</a>
      </div>

      <div class="user-actions">
        <template v-if="userStore.isLoggedIn">
          <el-dropdown>
            <span class="user-info">
              <el-avatar :size="32" :src="userStore.avatar">
                {{ userStore.username[0].toUpperCase() }}
              </el-avatar>
              <span class="username">{{ userStore.username }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goToUserCenter">个人中心</el-dropdown-item>
                <el-dropdown-item @click="goToLibrary">我的游戏库</el-dropdown-item>
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
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

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

const goToOrders = () => {
  router.push('/user/orders')
}

const goToAdmin = () => {
  router.push('/admin')
}

const handleLogout = () => {
  userStore.logout()
  ElMessage.success('已退出登录')
  router.push('/')
}
</script>

<style scoped lang="scss">
.navbar {
  background: linear-gradient(180deg, #171a21 0%, #10161f 100%);
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.navbar-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 68px;
}

.logo {
  font-size: 22px;
  font-weight: bold;
  color: #fff;
  cursor: pointer;
  letter-spacing: 1px;
  transition: color 0.25s;

  &:hover {
    color: #66c0f4;
  }
}

.nav-links {
  display: flex;
  gap: 30px;

  a {
    color: #d6e1ea;
    text-decoration: none;
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    transition: color 0.3s;

    &:hover {
      color: #66c0f4;
    }
  }
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 15px;

  .user-info {
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;

    .username {
      color: #ffffff;
      font-size: 14px;
    }
  }
}
</style>
