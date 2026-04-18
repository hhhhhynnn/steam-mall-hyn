# 仿 Steam 商城项目部署文档

## 项目简介

本项目是一个基于 Spring Boot、Vue 3 和 MySQL 技术栈的仿 Steam 商城系统，集成了 Redis 缓存和阿里云 OSS 对象存储。

## 技术栈

### 后端
- Java 17
- Spring Boot 3.2.0
- Spring Security + JWT
- Spring Data JPA
- MySQL 8.0+
- Redis
- 阿里云 OSS

### 前端
- Vue 3
- Vite 5
- Element Plus
- Pinia
- Vue Router
- ECharts

## 环境要求

- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Redis 6.0+
- Maven 3.6+

## 部署步骤

### 1. 数据库配置

#### 1.1 创建数据库
```bash
mysql -u root -p < steam-mall-backend/src/main/resources/db/schema.sql
```

#### 1.2 修改数据库配置
编辑 `steam-mall-backend/src/main/resources/application.yml`：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/steam_mall?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: your_username
    password: your_password
```

### 2. Redis 配置

编辑 `application.yml`：
```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password: 
```

### 3. 阿里云 OSS 配置

编辑 `application.yml`：
```yaml
aliyun:
  oss:
    endpoint: oss-cn-hangzhou.aliyuncs.com
    access-key-id: your-access-key-id
    access-key-secret: your-access-key-secret
    bucket-name: your-bucket-name
    base-url: https://your-bucket-name.oss-cn-hangzhou.aliyuncs.com
```

### 4. 后端部署

#### 4.1 编译打包
```bash
cd steam-mall-backend
mvn clean package -DskipTests
```

#### 4.2 运行
```bash
java -jar target/steam-mall-1.0.0.jar
```

或者使用 Maven 运行：
```bash
mvn spring-boot:run
```

后端服务将在 http://localhost:8080 启动

### 5. 前端部署

#### 5.1 安装依赖
```bash
cd steam-mall-frontend
npm install
```

#### 5.2 开发环境运行
```bash
npm run dev
```

前端服务将在 http://localhost:5173 启动

#### 5.3 生产环境构建
```bash
npm run build
```

构建产物在 `dist` 目录，可部署到 Nginx 或其他 Web 服务器

### 6. Nginx 配置（生产环境）

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态文件
    location / {
        root /path/to/dist;
        try_files $uri $uri/ /index.html;
    }

    # 后端 API 代理
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## 默认账号

### 超级管理员
- 用户名：admin
- 密码：admin123

## 主要功能

### 用户功能
- 用户注册/登录
- 游戏浏览和搜索
- 游戏购买和激活
- 个人游戏库
- 游戏评价
- 订单管理

### 管理员功能
- 游戏管理（增删改查）
- 图片和视频上传（阿里云 OSS）
- 数据统计和可视化

## 常见问题

### 1. 后端启动失败
- 检查 MySQL 是否运行
- 检查 Redis 是否运行
- 检查数据库配置是否正确
- 检查端口 8080 是否被占用

### 2. 前端无法连接后端
- 检查后端是否启动
- 检查代理配置（vite.config.js）
- 检查 CORS 配置

### 3. 文件上传失败
- 检查阿里云 OSS 配置
- 检查 OSS bucket 权限
- 检查文件大小限制

## 项目结构

```
steam-mall/
├── steam-mall-backend/          # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/steam/
│   │   │   │   ├── config/      # 配置类
│   │   │   │   ├── controller/  # 控制器
│   │   │   │   ├── entity/      # 实体类
│   │   │   │   ├── repository/  # 数据访问层
│   │   │   │   ├── service/     # 业务逻辑层
│   │   │   │   ├── security/    # 安全相关
│   │   │   │   ├── dto/         # 数据传输对象
│   │   │   │   └── util/        # 工具类
│   │   │   └── resources/
│   │   │       ├── application.yml
│   │   │       └── db/
│   │   │           └── schema.sql
│   │   └── test/
│   │       └── java/
│   └── pom.xml
│
└── steam-mall-frontend/         # 前端项目
    ├── src/
    │   ├── api/                 # API 接口
    │   ├── components/          # 组件
    │   ├── router/              # 路由配置
    │   ├── stores/              # Pinia 状态管理
    │   ├── utils/               # 工具函数
    │   ├── views/               # 页面视图
    │   ├── App.vue
    │   └── main.js
    ├── index.html
    ├── package.json
    └── vite.config.js
```

## 开发说明

### 后端开发
1. 使用 Lombok 简化代码
2. 遵循 RESTful API 设计规范
3. 使用 JWT 进行身份认证
4. 使用 Redis 缓存热点数据

### 前端开发
1. 使用 Vue 3 Composition API
2. 使用 Pinia 进行状态管理
3. 使用 Element Plus UI 组件库
4. 使用 Axios 进行 HTTP 请求

## 性能优化

1. **Redis 缓存**：缓存游戏列表、详情等热点数据
2. **数据库索引**：为常用查询字段添加索引
3. **CDN 加速**：使用阿里云 OSS CDN 加速静态资源
4. **前端优化**：路由懒加载、组件按需引入

## 安全建议

1. 修改 JWT 密钥（application.yml 中的 jwt.secret）
2. 修改默认管理员密码
3. 配置 HTTPS
4. 定期备份数据库
5. 限制 API 请求频率

## 联系方式

如有问题，请提交 Issue 或联系开发者。
