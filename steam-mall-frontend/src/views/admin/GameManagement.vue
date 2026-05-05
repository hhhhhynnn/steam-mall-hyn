<template>
  <div class="game-management">
    <div class="management-header">
      <div>
        <h2>游戏管理</h2>
      </div>
      <div class="header-actions">
        <el-button @click="goBack">返回后台</el-button>
        <el-button type="primary" @click="showAddDialog">添加游戏</el-button>
      </div>
    </div>

    <el-table class="admin-table" :data="games" style="width: 100%" v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="游戏名称" />
      <el-table-column label="分类" width="180">
        <template #default="{ row }">
          <el-tag
            v-for="cat in parseCategories(row.category)"
            :key="cat"
            size="small"
            style="margin-right: 6px; margin-bottom: 4px"
          >
            {{ cat }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="price" label="价格" width="100">
        <template #default="{ row }">
          ¥{{ row.price }}
        </template>
      </el-table-column>
      <el-table-column prop="salesCount" label="销量" width="100" />
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '上架' : '下架' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button size="small" @click="showEditDialog(row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination" v-if="total > 0">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="prev, pager, next"
        @current-change="loadGames"
      />
    </div>

    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑游戏' : '添加游戏'"
      width="800px"
    >
      <el-form :model="gameForm" label-width="100px">
        <el-form-item label="游戏名称">
          <el-input v-model="gameForm.name" />
        </el-form-item>
        <el-form-item label="游戏简介">
          <el-input v-model="gameForm.shortDescription" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="游戏描述">
          <el-input v-model="gameForm.description" type="textarea" :rows="5" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="gameForm.categories" multiple collapse-tags collapse-tags-tooltip>
            <el-option
              v-for="category in categoryOptions"
              :key="category.id"
              :label="category.name"
              :value="category.name"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number v-model="gameForm.price" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="折扣">
          <el-input-number v-model="gameForm.discount" :min="0" :max="100" />
        </el-form-item>
        <el-form-item label="开发商">
          <el-input v-model="gameForm.developer" />
        </el-form-item>
        <el-form-item label="发行商">
          <el-input v-model="gameForm.publisher" />
        </el-form-item>
        <el-form-item label="发行日期">
          <el-date-picker
            v-model="gameForm.releaseDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="封面图片">
          <el-upload
            class="image-uploader"
            :action="uploadUrl"
            :headers="uploadHeaders"
            :on-success="(res) => handleImageSuccess(res, 'cover')"
            :show-file-list="false"
          >
            <img v-if="gameForm.coverImage" :src="gameForm.coverImage" class="uploaded-image" />
            <el-icon v-else class="uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="横幅图片">
          <el-upload
            class="image-uploader"
            :action="uploadUrl"
            :headers="uploadHeaders"
            :on-success="(res) => handleImageSuccess(res, 'banner')"
            :show-file-list="false"
          >
            <img v-if="gameForm.bannerImage" :src="gameForm.bannerImage" class="uploaded-image" />
            <el-icon v-else class="uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="宣传视频">
          <el-upload
            class="video-uploader"
            :action="uploadVideoUrl"
            :headers="uploadHeaders"
            :on-success="(res) => handleVideoSuccess(res)"
            :show-file-list="false"
          >
            <video v-if="gameForm.videoUrl" :src="gameForm.videoUrl" controls class="uploaded-video" />
            <el-icon v-else class="uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="gameForm.status">
            <el-radio :label="1">上架</el-radio>
            <el-radio :label="0">下架</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCategories } from '@/api'

const router = useRouter()
const userStore = useUserStore()

const games = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const loading = ref(false)
const dialogVisible = ref(false)
const isEdit = ref(false)
const categoryOptions = ref([])

const gameForm = ref({
  name: '',
  shortDescription: '',
  description: '',
  categories: [],
  price: 0,
  discount: 0,
  finalPrice: 0,
  developer: '',
  publisher: '',
  releaseDate: '',
  coverImage: '',
  bannerImage: '',
  videoUrl: '',
  systemRequirements: '',
  tags: '',
  status: 1
})

const uploadUrl = '/api/admin/games/upload/image'
const uploadVideoUrl = '/api/admin/games/upload/video'
const uploadHeaders = computed(() => ({
  Authorization: `Bearer ${userStore.token}`
}))

const loadGames = async () => {
  loading.value = true
  try {
    const res = await fetch(`/api/admin/games?page=${currentPage.value - 1}&size=${pageSize.value}`, {
      headers: {
        Authorization: `Bearer ${userStore.token}`
      }
    })
    const data = await res.json()
    games.value = data.data.content || []
    total.value = data.data.totalElements || 0
  } catch (error) {
    ElMessage.error('加载游戏列表失败')
  } finally {
    loading.value = false
  }
}

const loadCategories = async () => {
  try {
    categoryOptions.value = await getCategories()
  } catch (error) {
    categoryOptions.value = []
    ElMessage.error('加载分类失败')
  }
}

const showAddDialog = () => {
  isEdit.value = false
  gameForm.value = {
    name: '',
    shortDescription: '',
    description: '',
    categories: [],
    price: 0,
    discount: 0,
    finalPrice: 0,
    developer: '',
    publisher: '',
    releaseDate: '',
    coverImage: '',
    bannerImage: '',
    videoUrl: '',
    systemRequirements: '',
    tags: '',
    status: 1
  }
  dialogVisible.value = true
}

const showEditDialog = (game) => {
  isEdit.value = true
  gameForm.value = {
    ...game,
    categories: parseCategories(game.category)
  }
  dialogVisible.value = true
}

const parseCategories = (categoryValue) => {
  if (!categoryValue) return []
  return String(categoryValue)
    .split(',')
    .map(item => item.trim())
    .filter(Boolean)
}

const handleImageSuccess = (res, type) => {
  if (type === 'cover') {
    gameForm.value.coverImage = res.data.url
  } else if (type === 'banner') {
    gameForm.value.bannerImage = res.data.url
  }
}

const handleVideoSuccess = (res) => {
  gameForm.value.videoUrl = res.data.url
}

const handleSubmit = async () => {
  try {
    const url = isEdit.value 
      ? `/api/admin/games/${gameForm.value.id}`
      : '/api/admin/games'
    
    const method = isEdit.value ? 'PUT' : 'POST'
    
    const payload = {
      ...gameForm.value,
      category: gameForm.value.categories.join(',')
    }

    const res = await fetch(url, {
      method,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${userStore.token}`
      },
      body: JSON.stringify(payload)
    })
    
    const data = await res.json()
    
    if (data.code === 200) {
      ElMessage.success(isEdit.value ? '更新成功' : '创建成功')
      dialogVisible.value = false
      loadGames()
    } else {
      ElMessage.error(data.message)
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (game) => {
  try {
    await ElMessageBox.confirm(`确定要删除游戏"${game.name}"吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    const res = await fetch(`/api/admin/games/${game.id}`, {
      method: 'DELETE',
      headers: {
        Authorization: `Bearer ${userStore.token}`
      }
    })
    
    const data = await res.json()
    
    if (data.code === 200) {
      ElMessage.success('删除成功')
      loadGames()
    } else {
      ElMessage.error(data.message)
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const goBack = () => {
  router.push('/admin')
}

onMounted(() => {
  loadCategories()
  loadGames()
})
</script>

<style scoped lang="scss">
.game-management {
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
    margin: 0;
    color: #ffffff;
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

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}

.pagination :deep(.el-pagination) {
  padding: 10px 12px;
  background: linear-gradient(180deg, rgba(31, 47, 69, 0.95) 0%, rgba(24, 38, 56, 0.95) 100%);
  border: 1px solid rgba(102, 192, 244, 0.2);
  border-radius: 3px;
}

.pagination :deep(.el-pagination button),
.pagination :deep(.el-pager li) {
  background: #171a21;
  color: #c7d5e0;
  border: 1px solid rgba(102, 192, 244, 0.18);
}

.pagination :deep(.el-pagination button:hover),
.pagination :deep(.el-pager li:hover) {
  color: #66c0f4;
  border-color: rgba(102, 192, 244, 0.45);
}

.pagination :deep(.el-pager li.is-active) {
  background: linear-gradient(180deg, #66c0f4 0%, #2a75a3 100%);
  border-color: rgba(102, 192, 244, 0.75);
  color: #ffffff;
}

.pagination :deep(.el-pagination button:disabled) {
  background: rgba(23, 26, 33, 0.58);
  color: #5d7284;
  border-color: rgba(102, 192, 244, 0.1);
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
:deep(.el-textarea__inner),
:deep(.el-select__wrapper) {
  background: #171a21;
  border: 1px solid rgba(102, 192, 244, 0.2);
  box-shadow: none;
}

:deep(.el-input__inner),
:deep(.el-textarea__inner),
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

.image-uploader {
  border: 1px dashed rgba(102, 192, 244, 0.35);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 150px;
  height: 85px;
  background: rgba(23, 26, 33, 0.72);

  &:hover {
    border-color: #66c0f4;
  }

  .uploaded-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .uploader-icon {
    font-size: 28px;
    color: #8fa7bf;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.video-uploader {
  border: 1px dashed rgba(102, 192, 244, 0.35);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 200px;
  height: 120px;
  background: rgba(23, 26, 33, 0.72);

  &:hover {
    border-color: #66c0f4;
  }

  .uploaded-video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .uploader-icon {
    font-size: 28px;
    color: #8fa7bf;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
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
