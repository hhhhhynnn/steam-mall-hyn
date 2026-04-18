import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('token') || '')
  const username = ref(localStorage.getItem('username') || '')
  const role = ref(localStorage.getItem('role') || '')
  const userId = ref(localStorage.getItem('userId') || '')

  const isLoggedIn = ref(!!token.value)

  function setToken(newToken, newUsername, newRole, newUserId) {
    token.value = newToken
    username.value = newUsername
    role.value = newRole
    userId.value = newUserId
    isLoggedIn.value = true
    
    localStorage.setItem('token', newToken)
    localStorage.setItem('username', newUsername)
    localStorage.setItem('role', newRole)
    localStorage.setItem('userId', newUserId)
  }

  function logout() {
    token.value = ''
    username.value = ''
    role.value = ''
    userId.value = ''
    isLoggedIn.value = false
    
    localStorage.removeItem('token')
    localStorage.removeItem('username')
    localStorage.removeItem('role')
    localStorage.removeItem('userId')
  }

  return {
    token,
    username,
    role,
    userId,
    isLoggedIn,
    setToken,
    logout
  }
})
