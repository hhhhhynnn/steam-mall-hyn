<template>
  <div class="user-library">
    <Navbar />
    
    <div class="library-content">
      <h2>我的游戏库</h2>
      
      <!-- 激活码区域 -->
      <div class="activate-section">
        <el-card class="activate-card">
          <h3>🔑 激活游戏</h3>
          <el-input
            v-model="activationCode"
            placeholder="请输入激活码（格式：XXXX-XXXX-XXXX-XXXX）"
            class="activate-input"
            maxlength="19"
          >
            <template #append>
              <el-button type="primary" @click="handleActivate" :loading="activating">
                激活游戏
              </el-button>
            </template>
          </el-input>
        </el-card>
      </div>
      
      <div class="library-grid">
        <div 
          class="game-card" 
          v-for="game in games" 
          :key="game.id"
          @click="goToGame(game.id)"
        >
          <img :src="game.coverImage" :alt="game.name" class="game-image" />
          <div class="game-info">
            <div class="game-name">{{ game.name }}</div>
            <div class="game-meta">
              <span class="category">{{ formatCategories(game.category) }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="no-games" v-if="games.length === 0">
        <el-empty description="您还没有任何游戏">
          <el-button type="primary" @click="goToStore">去商店逛逛</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getUserGames, activateGameCode } from '@/api'
import { ElMessage } from 'element-plus'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()
const games = ref([])
const activationCode = ref('')
const activating = ref(false)

const loadLibrary = async () => {
  try {
    games.value = await getUserGames()
  } catch (error) {
    console.error(error)
  }
}

const goToGame = (id) => {
  router.push(`/game/${id}`)
}

const goToStore = () => {
  router.push('/')
}

const handleActivate = async () => {
  if (!activationCode.value.trim()) {
    ElMessage.warning('请输入激活码')
    return
  }

  // 验证格式
  const codeRegex = /^[A-HJ-NP-Z2-9]{4}-[A-HJ-NP-Z2-9]{4}-[A-HJ-NP-Z2-9]{4}-[A-HJ-NP-Z2-9]{4}$/
  if (!codeRegex.test(activationCode.value)) {
    ElMessage.error('激活码格式不正确')
    return
  }

  activating.value = true
  try {
    await activateGameCode(activationCode.value)
    ElMessage.success('激活成功！游戏已添加到您的游戏库')
    activationCode.value = ''
    loadLibrary()  // 刷新游戏库
  } catch (error) {
    ElMessage.error('激活失败：' + (error.message || '未知错误'))
  } finally {
    activating.value = false
  }
}

const formatCategories = (categoryValue) => {
  if (!categoryValue) return ''
  return String(categoryValue)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
    .join(' / ')
}

onMounted(() => {
  loadLibrary()
})
</script>

<style scoped lang="scss">
.user-library {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.library-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 40px 20px;

  h2 {
    color: #ffffff;
    margin-bottom: 30px;
  }
}

.activate-section {
  margin-bottom: 40px;

  .activate-card {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    
    h3 {
      color: #ffffff;
      font-size: 18px;
      margin-bottom: 16px;
    }

    .activate-input {
      :deep(.el-input__wrapper) {
        background: rgba(0, 0, 0, 0.3);
        border-color: rgba(255, 255, 255, 0.2);
      }

      :deep(.el-input__inner) {
        color: #ffffff;
      }
    }
  }
}

.library-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
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
    height: 280px;
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

    .game-meta {
      .category {
        color: #8b929a;
        font-size: 12px;
      }
    }
  }
}

.no-games {
  padding: 60px 0;
  text-align: center;
}
</style>
