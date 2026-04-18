// steam-mall-frontend/src/api/hotSale.js
import request from '@/utils/request'

/**
 * 获取热销榜列表
 * @param {string} periodType - 统计周期：ALL/DAILY/WEEKLY/MONTHLY
 */
export function getHotSaleList(periodType = 'ALL') {
    return request({
        url: '/hot-sale',
        method: 'get',
        params: { periodType }
    })
}