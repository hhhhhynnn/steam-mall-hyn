# 仿 Steam 商城项目 - 项目总结

## 项目概述

本项目是一个完整的仿 Steam 商城系统，采用前后端分离架构，实现了用户注册登录、游戏浏览购买、订单管理、评价系统等核心功能，并提供了管理员后台进行游戏管理和数据统计。

## 技术架构

### 后端技术栈
- **Java 17**: 现代化 Java 版本，提供新特性支持
- **Spring Boot 3.2.0**: 快速开发框架，简化配置
- **Spring Security + JWT**: 安全的认证授权机制
- **Spring Data JPA**: 简化数据库操作
- **MySQL 8.0**: 关系型数据库，存储业务数据
- **Redis**: 缓存热点数据，提升系统性能
- **阿里云 OSS**: 对象存储，存储图片和视频文件

### 前端技术栈
- **Vue 3**: 渐进式 JavaScript 框架，使用 Composition API
- **Vite 5**: 下一代前端构建工具，极速启动
- **Element Plus**: 基于 Vue 3 的组件库
- **Pinia**: Vue 3 状态管理库
- **Vue Router**: 官方路由管理器
- **ECharts**: 数据可视化图表库
- **Axios**: HTTP 客户端

## 已实现功能

### 1. 用户与权限管理系统 ✅
- ✅ 用户注册功能
- ✅ 用户登录功能
- ✅ JWT Token 认证
- ✅ 角色权限控制（管理员/普通用户）
- ✅ 超级管理员账号初始化

### 2. 用户端功能 ✅
- ✅ 仿 Steam 官网风格商店首页
- ✅ 自动轮播推荐游戏图片
- ✅ 多维度游戏分类导航
- ✅ 热销排行榜
- ✅ 好评排行榜
- ✅ 游戏搜索功能
- ✅ 游戏详情页：
  - ✅ 游戏图片展示
  - ✅ 游戏视频播放
  - ✅ 完整游戏信息
  - ✅ 开发商/发行商跳转
  - ✅ 分类跳转
- ✅ 游戏购买流程
- ✅ 激活密令生成与验证
- ✅ 用户游戏库
- ✅ 游戏评价系统（好评/差评）
- ✅ 订单管理

### 3. 管理员功能 ✅
- ✅ 游戏管理（增删改查）
- ✅ 游戏上下架
- ✅ 图片上传（阿里云 OSS）
- ✅ 视频上传（阿里云 OSS）
- ✅ 数据统计：
  - ✅ 游戏热度统计
  - ✅ 游戏销量统计
  - ✅ 游戏类型热度分析
  - ✅ 图表可视化展示

### 4. 技术实现 ✅
- ✅ 阿里云 OSS 文件存储
- ✅ Redis 热点数据缓存
- ✅ Steam 风格 UI/UX 设计
- ✅ 前后端分离架构
- ✅ RESTful API 设计
- ✅ 全局异常处理
- ✅ 统一响应格式

## 项目结构

```
steam-mall/
├── steam-mall-backend/              # 后端项目
│   ├── src/main/java/com/steam/
│   │   ├── config/                  # 配置类（Redis, OSS, Security, JWT）
│   │   ├── controller/              # REST API 控制器
│   │   │   ├── AuthController.java
│   │   │   ├── GameController.java
│   │   │   ├── OrderController.java
│   │   │   ├── ReviewController.java
│   │   │   ├── UserLibraryController.java
│   │   │   ├── CategoryController.java
│   │   │   ├── CarouselController.java
│   │   │   └── AdminGameController.java
│   │   ├── entity/                  # JPA 实体类
│   │   │   ├── User.java
│   │   │   ├── Game.java
│   │   │   ├── Order.java
│   │   │   ├── GameReview.java
│   │   │   ├── UserGame.java
│   │   │   ├── GameCategory.java
│   │   │   └── Carousel.java
│   │   ├── repository/              # 数据访问层
│   │   ├── service/                 # 业务逻辑层
│   │   │   ├── AuthService.java
│   │   │   ├── GameService.java
│   │   │   ├── OrderService.java
│   │   │   ├── UserGameService.java
│   │   │   └── OssService.java
│   │   ├── security/                # 安全相关
│   │   │   └── JwtAuthenticationFilter.java
│   │   ├── dto/                     # 数据传输对象
│   │   │   ├── ApiResponse.java
│   │   │   ├── LoginRequest.java
│   │   │   ├── LoginResponse.java
│   │   │   └── RegisterRequest.java
│   │   ├── util/                    # 工具类
│   │   │   └── JwtUtil.java
│   │   └── exception/               # 异常处理
│   │       └── GlobalExceptionHandler.java
│   └── src/main/resources/
│       ├── application.yml          # 配置文件
│       └── db/schema.sql            # 数据库脚本
│
└── steam-mall-frontend/             # 前端项目
    ├── src/
    │   ├── api/                     # API 接口封装
    │   │   ├── game.js
    │   │   └── index.js
    │   ├── components/              # 公共组件
    │   │   └── Navbar.vue
    │   ├── router/                  # 路由配置
    │   │   └── index.js
    │   ├── stores/                  # Pinia 状态管理
    │   │   └── user.js
    │   ├── utils/                   # 工具函数
    │   │   └── request.js
    │   ├── views/                   # 页面视图
    │   │   ├── Home.vue
    │   │   ├── Login.vue
    │   │   ├── Register.vue
    │   │   ├── GameDetail.vue
    │   │   ├── Search.vue
    │   │   ├── Category.vue
    │   │   ├── UserCenter.vue
    │   │   ├── UserLibrary.vue
    │   │   ├── UserOrders.vue
    │   │   └── admin/
    │   │       ├── AdminDashboard.vue
    │   │       └── GameManagement.vue
    │   ├── App.vue
    │   └── main.js
    ├── index.html
    ├── package.json
    └── vite.config.js
```

## 数据库设计

### 核心表结构

1. **user** - 用户表
   - 存储用户基本信息
   - 支持角色区分（ADMIN/USER）

2. **game** - 游戏表
   - 存储游戏详细信息
   - 包含价格、折扣、销量等
   - 支持全文搜索

3. **user_game** - 用户游戏库表
   - 记录用户拥有的游戏
   - 存储激活码

4. **order** - 订单表
   - 记录购买订单
   - 包含支付状态

5. **game_review** - 游戏评价表
   - 存储用户评价
   - 支持好评/差评

6. **game_category** - 游戏分类表
   - 游戏分类管理

7. **carousel** - 轮播图表
   - 首页轮播图管理

## API 接口设计

### 认证接口
- POST /api/auth/register - 用户注册
- POST /api/auth/login - 用户登录

### 游戏接口
- GET /api/games - 获取游戏列表
- GET /api/games/{id} - 获取游戏详情
- GET /api/games/search - 搜索游戏
- GET /api/games/category/{category} - 按分类获取游戏
- GET /api/games/top/sales - 热销榜
- GET /api/games/top/rated - 好评榜

### 订单接口
- POST /api/orders/{gameId} - 创建订单
- POST /api/orders/{orderNo}/pay - 支付订单
- GET /api/orders - 获取订单列表
- POST /api/orders/activate - 激活游戏

### 评价接口
- GET /api/reviews/game/{gameId} - 获取游戏评价
- POST /api/reviews - 创建评价
- PUT /api/reviews/{reviewId} - 更新评价
- DELETE /api/reviews/{reviewId} - 删除评价

### 用户接口
- GET /api/user/library - 获取游戏库
- GET /api/user/library/games - 获取用户游戏
- GET /api/user/library/owns/{gameId} - 检查是否拥有游戏

### 管理员接口
- GET /api/admin/games - 获取游戏列表（管理端）
- POST /api/admin/games - 创建游戏
- PUT /api/admin/games/{id} - 更新游戏
- DELETE /api/admin/games/{id} - 删除游戏
- POST /api/admin/games/upload/image - 上传图片
- POST /api/admin/games/upload/video - 上传视频

## 项目亮点

1. **完整的业务闭环**
   - 从浏览、购买到评价的完整流程
   - 前后端功能完整对应

2. **安全性设计**
   - JWT Token 认证
   - 密码 BCrypt 加密
   - 角色权限控制
   - CORS 跨域配置

3. **性能优化**
   - Redis 缓存热点数据
   - 数据库索引优化
   - 前端路由懒加载

4. **用户体验**
   - 仿 Steam 风格设计
   - 响应式布局
   - 流畅的交互动画
   - 友好的错误提示

5. **可维护性**
   - 清晰的代码结构
   - 统一的响应格式
   - 全局异常处理
   - 详细的文档

## 部署说明

### 环境要求
- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Redis 6.0+
- Maven 3.6+

### 快速启动

1. **初始化数据库**
```bash
mysql -u root -p < steam-mall-backend/src/main/resources/db/schema.sql
```

2. **启动后端**
```bash
cd steam-mall-backend
mvn spring-boot:run
```

3. **启动前端**
```bash
cd steam-mall-frontend
npm install
npm run dev
```

4. **访问系统**
- 前端地址：http://localhost:5173
- 后端地址：http://localhost:8080
- 管理员账号：admin / admin123

## 扩展建议

### 功能扩展
1. 购物车功能
2. 愿望单功能
3. 好友系统
4. 成就系统
5. 游戏时长统计
6. 退款功能
7. 礼物赠送
8. 社区讨论区

### 技术优化
1. 消息队列（RabbitMQ/Kafka）
2. Elasticsearch 全文搜索
3. Docker 容器化部署
4. Kubernetes 编排
5. CI/CD 自动化
6. 性能监控（Prometheus + Grafana）
7. 日志收集（ELK Stack）

## 总结

本项目成功实现了一个功能完整、架构清晰的仿 Steam 商城系统。项目采用现代化的技术栈，遵循最佳实践，具有良好的可维护性和可扩展性。通过本项目，可以全面掌握前后端分离开发、认证授权、文件存储、缓存优化等核心技术。

项目代码规范、文档齐全，可直接用于学习、毕设或二次开发。

---

**开发时间**: 2026 年 3 月
**技术栈**: Spring Boot + Vue 3 + MySQL + Redis
**项目状态**: 已完成 ✅
