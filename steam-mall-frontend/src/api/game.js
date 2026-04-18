import request from '@/utils/request'

export function login(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

export function register(data) {
  return request({
    url: '/auth/register',
    method: 'post',
    data
  })
}

export function getGames(params) {
  return request({
    url: '/games',
    method: 'get',
    params
  })
}

export function getGameById(id) {
  return request({
    url: `/games/${id}`,
    method: 'get'
  })
}

export function searchGames(keyword, params) {
  return request({
    url: '/games/search',
    method: 'get',
    params: {
      keyword,
      ...params
    }
  })
}

export function getTopSalesGames(params) {
  return request({
    url: '/games/top/sales',
    method: 'get',
    params
  })
}

export function getTopRatedGames(params) {
  return request({
    url: '/games/top/rated',
    method: 'get',
    params
  })
}

export function getGamesByCategory(category, params) {
  return request({
    url: `/games/category/${category}`,
    method: 'get',
    params
  })
}

export function getGamesByDeveloper(developer, params) {
  return request({
    url: `/games/developer/${developer}`,
    method: 'get',
    params
  })
}

export function getGamesByPublisher(publisher) {
  return request({
    url: `/games/publisher/${publisher}`,
    method: 'get'
  })
}
