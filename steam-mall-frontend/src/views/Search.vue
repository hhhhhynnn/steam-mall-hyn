<template>
  <div class="search-page">
    <Navbar />
    
    <div class="search-content">
      <h2>搜索结果：{{ keyword }}</h2>
      
      <div class="games-grid">
        <div 
          class="game-card" 
          v-for="game in games" 
          :key="game.id"
          @click="goToGame(game.id)"
        >
          <img :src="game.coverImage" :alt="game.name" class="game-image" />
          <div class="game-info">
            <div class="game-name">{{ game.name }}</div>
            <div class="game-price">
              <span v-if="game.discount > 0" class="discount">-{{ game.discount }}%</span>
              <span class="price">¥{{ game.finalPrice || game.price }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="pagination" v-if="total > 0">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="loadGames"
        />
      </div>

      <div class="no-results" v-if="games.length === 0 && !loading">
        <el-empty description="未找到相关游戏" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { searchGames } from '@/api/game'
import Navbar from '@/components/Navbar.vue'

const route = useRoute()
const router = useRouter()

const games = ref([])
const keyword = ref('')
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)
const loading = ref(false)

const loadGames = async () => {
  if (!keyword.value) return
  
  loading.value = true
  try {
    const res = await searchGames(keyword.value, {
      page: currentPage.value - 1,
      size: pageSize.value
    })
    games.value = res.content || []
    total.value = res.totalElements || 0
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const goToGame = (id) => {
  router.push(`/game/${id}`)
}

watch(() => route.query.q, (newQ) => {
  if (newQ) {
    keyword.value = newQ
    currentPage.value = 1
    loadGames()
  }
}, { immediate: true })

onMounted(() => {
  if (route.query.q) {
    keyword.value = route.query.q
    loadGames()
  }
})
</script>

<style scoped lang="scss">
.search-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.search-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 40px 20px;

  h2 {
    color: #ffffff;
    margin-bottom: 30px;
  }
}

.games-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.game-card {
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
  }

  .game-image {
    width: 100%;
    height: 160px;
    object-fit: cover;
  }

  .game-info {
    padding: 12px;

    .game-name {
      color: #fff;
      font-size: 14px;
      margin-bottom: 8px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .game-price {
      display: flex;
      align-items: center;
      gap: 8px;

      .discount {
        background: #4c6b22;
        color: #a4d007;
        padding: 2px 6px;
        border-radius: 2px;
        font-size: 12px;
      }

      .price {
        color: #c7d5e0;
        font-size: 14px;
      }
    }
  }
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}

.no-results {
  text-align: center;
  padding: 60px 0;
}
</style>
