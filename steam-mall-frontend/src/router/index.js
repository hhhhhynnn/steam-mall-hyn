import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue')
  },
  {
    path: '/game/:id',
    name: 'GameDetail',
    component: () => import('@/views/GameDetail.vue')
  },
  {
    path: '/hot-sale',
    name: 'HotSale',
    component: () => import('@/views/HotSale.vue')
  },
  {
    path: '/search',
    name: 'Search',
    component: () => import('@/views/Search.vue')
  },
  {
    path: '/category/:category',
    name: 'Category',
    component: () => import('@/views/Category.vue')
  },
  {
    path: '/developer/:developer',
    name: 'Developer',
    component: () => import('@/views/Developer.vue')
  },
  {
    path: '/user',
    name: 'UserCenter',
    component: () => import('@/views/UserCenter.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/user/library',
    name: 'UserLibrary',
    component: () => import('@/views/UserLibrary.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/user/orders',
    name: 'UserOrders',
    component: () => import('@/views/UserOrders.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/admin/AdminDashboard.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  },
  {
    path: '/admin/games',
    name: 'AdminGames',
    component: () => import('@/views/admin/GameManagement.vue'),
    meta: { requiresAuth: true, requiresAdmin: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  
  if (to.meta.requiresAuth && !userStore.isLoggedIn) {
    next('/login')
  } else if (to.meta.requiresAdmin && userStore.role !== 'ADMIN') {
    next('/')
  } else {
    next()
  }
})

export default router
