<template>
  <div class="register-page">
    <Navbar />
    
    <div class="register-container">
      <div class="register-box">
        <h2>创建新账号</h2>
        
        <el-form :model="registerForm" :rules="rules" ref="formRef" label-width="80px">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="registerForm.username" placeholder="请输入用户名" />
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input v-model="registerForm.password" type="password" placeholder="请输入密码" show-password />
          </el-form-item>
          
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input v-model="registerForm.confirmPassword" type="password" placeholder="请再次输入密码" show-password />
          </el-form-item>
          
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="registerForm.email" placeholder="请输入邮箱（选填）" />
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" :loading="loading" @click="handleRegister" style="width: 100%">
              注册
            </el-button>
          </el-form-item>
          
          <div class="login-link">
            已有账号？<router-link to="/login">立即登录</router-link>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/api/game'
import { ElMessage } from 'element-plus'
import Navbar from '@/components/Navbar.vue'

const router = useRouter()
const formRef = ref(null)
const loading = ref(false)

const registerForm = ref({
  username: '',
  password: '',
  confirmPassword: '',
  email: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.value.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 50, message: '用户名长度必须在 3-50 之间', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于 6 位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ]
}

const handleRegister = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        const { confirmPassword, ...registerData } = registerForm.value
        await register(registerData)
        ElMessage.success('注册成功，请登录')
        router.push('/login')
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
.register-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1b2838 0%, #2a475e 100%);
}

.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 20px;
}

.register-box {
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

.login-link {
  text-align: center;
  margin-top: 20px;
  color: #c7d5e0;

  a {
    color: #66c0f4;
    margin-left: 5px;
  }
}
</style>
