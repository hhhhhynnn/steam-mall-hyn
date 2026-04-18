<template>
  <div class="game-management">
    <div class="management-header">
      <h2>游戏管理</h2>
      <el-button type="primary" @click="showAddDialog">添加游戏</el-button>
    </div>

    <el-table :data="games" style="width: 100%" v-loading="loading">
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
import { useUserStore } from '@/stores/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCategories } from '@/api'

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

onMounted(() => {
  loadCategories()
  loadGames()
})
</script>

<style scoped lang="scss">
.game-management {
  padding: 20px;
}

.management-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;

  h2 {
    color: #ffffff;
  }
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.image-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 150px;
  height: 85px;

  &:hover {
    border-color: #409EFF;
  }

  .uploaded-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.video-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 200px;
  height: 120px;

  &:hover {
    border-color: #409EFF;
  }

  .uploaded-video {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}
</style>
