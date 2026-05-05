<template>
  <div class="featured-management">
    <div class="management-header">
      <div>
        <h2>精选推荐管理</h2>
      </div>
      <div class="header-actions">
        <el-button @click="goBack">返回后台</el-button>
        <el-button type="primary" @click="openCreateDialog">新增推荐</el-button>
      </div>
    </div>

    <el-table class="admin-table" :data="featuredGames" style="width: 100%" v-loading="loading">
      <el-table-column label="排序" prop="sortOrder" width="90" />
      <el-table-column label="封面" width="180">
        <template #default="{ row }">
          <img :src="row.imageUrl" :alt="row.title" class="preview-image" />
        </template>
      </el-table-column>
      <el-table-column label="推荐标题" min-width="180">
        <template #default="{ row }">
          <div class="title-cell">
            <div class="title">{{ row.title }}</div>
            <div class="subtitle">{{ row.gameName }}</div>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="游戏分类" prop="category" width="180" />
      <el-table-column label="价格" width="120">
        <template #default="{ row }">
          <span class="price">¥{{ row.finalPrice ?? row.price }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">
            {{ row.status === 1 ? '展示中' : '已下线' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="220" fixed="right">
        <template #default="{ row }">
          <el-button size="small" @click="openEditDialog(row)">编辑</el-button>
          <el-button size="small" @click="goToGame(row.gameId)">查看游戏</el-button>
          <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑精选推荐' : '新增精选推荐'"
      width="640px"
    >
      <el-form :model="form" label-width="100px">
        <el-form-item label="投放游戏">
          <el-select
            v-model="form.targetId"
            filterable
            placeholder="请选择要投放的游戏"
            style="width: 100%"
          >
            <el-option
              v-for="game in gameOptions"
              :key="game.id"
              :label="game.name"
              :value="game.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="推荐标题">
          <el-input v-model="form.title" maxlength="60" placeholder="为空时默认显示游戏名" />
        </el-form-item>
        <el-form-item label="展示顺序">
          <el-input-number v-model="form.sortOrder" :min="0" :max="999" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">展示</el-radio>
            <el-radio :label="0">下线</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createFeaturedCarousel,
  deleteFeaturedCarousel,
  getAdminFeaturedCarousels,
  updateFeaturedCarousel
} from '@/api'

const router = useRouter()
const userStore = useUserStore()

const featuredGames = ref([])
const gameOptions = ref([])
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)

const createDefaultForm = () => ({
  id: null,
  targetId: null,
  title: '',
  sortOrder: 0,
  status: 1
})

const form = ref(createDefaultForm())

const loadFeaturedGames = async () => {
  loading.value = true
  try {
    featuredGames.value = await getAdminFeaturedCarousels()
  } finally {
    loading.value = false
  }
}

const loadGameOptions = async () => {
  const response = await fetch('/api/admin/games?page=0&size=200', {
    headers: {
      Authorization: `Bearer ${userStore.token}`
    }
  })
  const data = await response.json()
  if (data.code !== 200) {
    throw new Error(data.message || '加载游戏列表失败')
  }
  gameOptions.value = data.data.content || []
}

const openCreateDialog = () => {
  isEdit.value = false
  form.value = createDefaultForm()
  dialogVisible.value = true
}

const openEditDialog = (row) => {
  isEdit.value = true
  form.value = {
    id: row.carouselId,
    targetId: row.gameId,
    title: row.title,
    sortOrder: row.sortOrder ?? 0,
    status: row.status ?? 1
  }
  dialogVisible.value = true
}

const handleSubmit = async () => {
  if (!form.value.targetId) {
    ElMessage.error('请先选择要投放的游戏')
    return
  }

  const payload = {
    targetId: form.value.targetId,
    title: form.value.title?.trim() || '',
    sortOrder: form.value.sortOrder ?? 0,
    status: form.value.status
  }

  if (isEdit.value) {
    await updateFeaturedCarousel(form.value.id, payload)
  } else {
    await createFeaturedCarousel(payload)
  }

  ElMessage.success(isEdit.value ? '精选推荐已更新' : '精选推荐已创建')
  dialogVisible.value = false
  await loadFeaturedGames()
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定删除推荐位“${row.title}”吗？`, '提示', {
      type: 'warning'
    })
    await deleteFeaturedCarousel(row.carouselId)
    ElMessage.success('精选推荐已删除')
    await loadFeaturedGames()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const goBack = () => {
  router.push('/admin')
}

const goToGame = (gameId) => {
  router.push(`/game/${gameId}`)
}

onMounted(async () => {
  try {
    await Promise.all([loadFeaturedGames(), loadGameOptions()])
  } catch (error) {
    ElMessage.error(error.message || '加载精选推荐失败')
  }
})
</script>

<style scoped lang="scss">
.featured-management {
  min-height: 100vh;
  padding: 24px;
  background:
    radial-gradient(circle at top, rgba(102, 192, 244, 0.13) 0%, transparent 34%),
    linear-gradient(180deg, #1b2838 0%, #101822 100%);
}

.management-header {
  max-width: 1400px;
  margin: 0 auto 24px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;

  h2 {
    margin: 0 0 8px;
    color: #fff;
  }

  p {
    margin: 0;
    color: #a7b9cc;
  }
}

.header-actions {
  display: flex;
  gap: 12px;
}

.admin-table {
  max-width: 1400px;
  margin: 0 auto;
  border: 1px solid rgba(102, 192, 244, 0.18);
  border-radius: 6px;
  overflow: hidden;
  --el-table-bg-color: rgba(24, 38, 56, 0.96);
  --el-table-tr-bg-color: rgba(24, 38, 56, 0.96);
  --el-table-header-bg-color: #171a21;
  --el-table-header-text-color: #c7d5e0;
  --el-table-text-color: #dbe9f4;
  --el-table-border-color: rgba(102, 192, 244, 0.16);
  --el-table-row-hover-bg-color: rgba(102, 192, 244, 0.13);
}

.admin-table :deep(.el-table__inner-wrapper::before),
.admin-table :deep(.el-table__border-left-patch) {
  background-color: rgba(102, 192, 244, 0.16);
}

.admin-table :deep(.el-table__fixed-right),
.admin-table :deep(.el-table__fixed-right .el-table__fixed-body-wrapper),
.admin-table :deep(.el-table__fixed-right .el-table__fixed-header-wrapper) {
  background: #182638;
}

.preview-image {
  width: 150px;
  height: 70px;
  border-radius: 6px;
  object-fit: cover;
}

.title-cell {
  .title {
    color: #fff;
    font-weight: 600;
    margin-bottom: 4px;
  }

  .subtitle {
    color: #9cb3c9;
    font-size: 13px;
  }
}

.price {
  color: #a4d007;
  font-weight: 600;
}

:deep(.el-dialog) {
  background: linear-gradient(180deg, #1b2838 0%, #111b27 100%);
  border: 1px solid rgba(102, 192, 244, 0.22);
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.46);
}

:deep(.el-dialog__title),
:deep(.el-form-item__label),
:deep(.el-radio) {
  color: #c7d5e0;
}

:deep(.el-dialog__headerbtn .el-dialog__close) {
  color: #8fa7bf;
}

:deep(.el-input__wrapper),
:deep(.el-select__wrapper) {
  background: #171a21;
  border: 1px solid rgba(102, 192, 244, 0.2);
  box-shadow: none;
}

:deep(.el-input__inner),
:deep(.el-select__placeholder),
:deep(.el-select__selected-item) {
  color: #dbe9f4;
}

:deep(.el-input-number__decrease),
:deep(.el-input-number__increase) {
  background: #22384d;
  border-color: rgba(102, 192, 244, 0.2);
  color: #c7d5e0;
}

@media (max-width: 760px) {
  .management-header {
    flex-direction: column;
    align-items: stretch;
  }

  .header-actions {
    flex-wrap: wrap;
  }
}
</style>
