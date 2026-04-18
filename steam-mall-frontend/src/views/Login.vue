<template>
  <div class="login-page">
    <Navbar />
    
    <div class="login-container">
      <div class="login-box">
        <h2>登录到 Steam</h2>
        
        <el-form :model="loginForm" :rules="rules" ref="formRef" label-width="80px">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="loginForm.username" placeholder="请输入用户名" />
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" show-password />
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" :loading="loading" @click="handleLogin" style="width: 100%">
              登录
            </el-button>
          </el-form-item>
          
          <div class="register-link">
            还没有账号？<router-link to="/register">立即注册</router-link>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { login } from '@/api/game'
import { ElMessage } from 'element-plus'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref(null)
const loading = ref(false)

const loginForm = ref({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const res = await login(loginForm.value)
        userStore.setToken(res.token, res.username, res.role, res.userId)
        ElMessage.success('登录成功')
        router.push('/')
      } catch (error) {
        console.error(error)
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style scoped lang="scss">
.login-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 20px;
}

.login-box {
  background: rgba(0, 0, 0, 0.3);
  padding: 40px;
  border-radius: 8px;
  width: 100%;
  max-width: 450px;

  h2 {
    color: #ffffff;
    text-align: center;
    margin-bottom: 30px;
    font-size: 24px;
  }
}

.register-link {
  text-align: center;
  margin-top: 20px;
  color: #c7d5e0;

  a {
    color: #66c0f4;
    margin-left: 5px;
  }
}
</style>
