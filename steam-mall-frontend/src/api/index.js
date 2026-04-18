import request from '@/utils/request'

export function getCategories() {
  return request({
    url: '/categories',
    method: 'get'
  })
}

export function getCarousels() {
  return request({
    url: '/carousels',
    method: 'get'
  })
}

export function getUserLibrary() {
  return request({
    url: '/user/library',
    method: 'get'
  })
}

export function getUserGames() {
  return request({
    url: '/user/library/games',
    method: 'get'
  })
}

export function checkOwnership(gameId) {
  return request({
    url: `/user/library/owns/${gameId}`,
    method: 'get'
  })
}

export function createOrder(gameId) {
  return request({
    url: `/orders/${gameId}`,
    method: 'post'
  })
}

export function payOrder(orderNo) {
  return request({
    url: `/orders/${orderNo}/pay`,
    method: 'post'
  })
}

export function getUserOrders(params) {
  return request({
    url: '/orders',
    method: 'get',
    params
  })
}

/**
 * 激活游戏激活码
 */
export function activateGameCode(code) {
  return request({
    url: '/orders/activate',
    method: 'post',
    params: { activationCode: code }
  })
}

export function activateGame(activationCode) {
  return request({
    url: '/orders/activate',
    method: 'post',
    params: { activationCode }
  })
}

export function getGameReviews(gameId, params) {
  return request({
    url: `/reviews/game/${gameId}`,
    method: 'get',
    params
  })
}

export function createReview(data) {
  return request({
    url: '/reviews',
    method: 'post',
    params: data
  })
}

export function updateReview(reviewId, data) {
  return request({
    url: `/reviews/${reviewId}`,
    method: 'put',
    params: data
  })
}

export function deleteReview(reviewId) {
  return request({
    url: `/reviews/${reviewId}`,
    method: 'delete'
  })
}
