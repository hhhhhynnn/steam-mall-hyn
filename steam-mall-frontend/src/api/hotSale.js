import request from '@/utils/request'

export function getHotSaleList() {
  return request({
    url: '/hot-sale',
    method: 'get'
  })
}
