# 仿 Steam 商城项目使用说明

## 快速开始指南

### 第一步：准备工作

1. **安装必需软件**
   - 安装 JDK 17 或更高版本
   - 安装 Node.js 18 或更高版本
   - 安装 MySQL 8.0 或更高版本
   - 安装 Redis 6.0 或更高版本
   - 安装 Maven 3.6 或更高版本

2. **配置阿里云 OSS**（可选，用于文件上传）
   - 登录阿里云控制台
   - 创建 OSS Bucket
   - 获取 AccessKey ID 和 AccessKey Secret

### 第二步：初始化数据库

1. 启动 MySQL 服务

2. 执行数据库脚本：
```bash
# 方法 1：使用命令行
mysql -u root -p < steam-mall-backend/src/main/resources/db/schema.sql

# 方法 2：使用 MySQL Workbench 或其他工具
# 打开 schema.sql 文件并执行
```

3. 验证数据库创建成功：
```sql
USE steam_mall;
SHOW TABLES;
```

应该能看到以下表：
- user（用户表）
- game（游戏表）
- user_game（用户游戏库表）
- order（订单表）
- game_review（游戏评价表）
- game_category（游戏分类表）
- carousel（轮播图表）

### 第三步：配置后端

1. 打开 `steam-mall-backend/src/main/resources/application.yml`

2. 修改数据库配置：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/steam_mall?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root        # 改为你的 MySQL 用户名
    password: your_password  # 改为你的 MySQL 密码
```

3. 修改 Redis 配置（如果有密码）：
```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password: your_redis_password  # 如果有密码
```

4. 修改 JWT 密钥（重要）：
```yaml
jwt:
  secret: your-very-secret-key-change-this-in-production
```

5. 配置阿里云 OSS（可选）：
```yaml
aliyun:
  oss:
    endpoint: oss-cn-hangzhou.aliyuncs.com
    access-key-id: your-access-key-id
    access-key-secret: your-access-key-secret
    bucket-name: your-bucket-name
    base-url: https://your-bucket-name.oss-cn-hangzhou.aliyuncs.com
```

### 第四步：启动后端

```bash
# 进入后端项目目录
cd steam-mall-backend

# 编译并运行
mvn spring-boot:run

# 或者先打包再运行
mvn clean package -DskipTests
java -jar target/steam-mall-1.0.0.jar
```

启动成功后，你会看到类似日志：
```
Started SteamMallApplication in X.XXX seconds
```

访问 http://localhost:8080/api/games 测试后端是否正常

### 第五步：启动前端

```bash
# 进入前端项目目录
cd steam-mall-frontend

# 安装依赖（首次运行需要）
npm install

# 启动开发服务器
npm run dev
```

启动成功后，你会看到：
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
```

在浏览器中访问 http://localhost:5173 即可看到网站

## 功能使用

### 1. 普通用户功能

#### 注册账号
1. 点击首页右上角"注册"按钮
2. 填写用户名、密码、确认密码、邮箱（选填）
3. 点击"注册"按钮
4. 注册成功后跳转到登录页

#### 登录
1. 输入用户名和密码
2. 点击"登录"按钮
3. 登录成功后自动跳转回首页

#### 浏览游戏
- 首页展示所有游戏，支持分页
- 左侧边栏显示分类导航、热销榜、好评榜
- 顶部轮播图展示推荐游戏

#### 搜索游戏
- 在首页搜索框输入关键词
- 支持按游戏名称、描述、标签搜索

#### 查看游戏详情
- 点击任意游戏卡片进入详情页
- 查看游戏图片、视频、介绍、系统需求
- 查看其他玩家评价

#### 购买游戏
1. 在游戏详情页点击"立即购买"
2. 确认支付信息
3. 支付成功后获得激活码
4. 游戏自动添加到个人游戏库

#### 个人游戏库
1. 点击用户名 -> "我的游戏库"
2. 查看所有已拥有的游戏
3. 点击游戏可进入详情页

#### 订单管理
1. 点击用户名 -> "订单管理"
2. 查看所有订单记录
3. 可以复制激活码
4. 可以对未支付订单进行支付

#### 游戏评价
1. 在游戏详情页底部找到"玩家评价"
2. 只有拥有该游戏才能评价
3. 可以选择好评或差评
4. 可以填写评价内容

### 2. 管理员功能

#### 登录管理员账号
- 用户名：admin
- 密码：admin123

#### 访问管理后台
1. 登录后点击用户名 -> "管理后台"
2. 查看数据统计图表
   - 游戏总数
   - 总销量
   - 用户总数
   - 总收入
   - 游戏类型分布图
   - 销量统计图

#### 游戏管理
1. 点击"游戏管理"菜单
2. 查看游戏列表
3. 添加游戏：
   - 点击"添加游戏"按钮
   - 填写游戏信息
   - 上传封面图片
   - 设置价格和折扣
   - 选择分类
   - 设置状态（上架/下架）
   - 点击"确定"保存
4. 编辑游戏：
   - 点击游戏行的"编辑"按钮
   - 修改游戏信息
   - 点击"确定"保存
5. 删除游戏：
   - 点击游戏行的"删除"按钮
   - 确认删除

## 常见问题

### Q1: 前端无法连接后端
**解决方案：**
- 确保后端已启动（访问 http://localhost:8080/api/games 测试）
- 检查 vite.config.js 中的代理配置
- 清除浏览器缓存

### Q2: 登录失败
**解决方案：**
- 检查数据库是否正常运行
- 确认用户名和密码正确
- 检查后端日志查看具体错误

### Q3: 文件上传失败
**解决方案：**
- 检查阿里云 OSS 配置是否正确
- 确认 OSS Bucket 权限设置
- 检查文件大小是否超过限制（图片 10MB，视频 100MB）

### Q4: Redis 连接失败
**解决方案：**
- 启动 Redis 服务
- 检查 Redis 配置
- 如果使用 Windows，确保 Redis 服务正在运行

### Q5: 数据库连接失败
**解决方案：**
- 确保 MySQL 服务已启动
- 检查数据库用户名和密码
- 确认 steam_mall 数据库已创建
- 检查 MySQL 版本是否为 8.0+

## 测试数据

项目启动后会自动创建以下测试数据：

### 管理员账号
- 用户名：admin
- 密码：admin123
- 角色：管理员

### 游戏分类
- 动作、冒险、策略、角色扮演、模拟、体育、竞速、独立、多人、免费开玩

### 添加测试游戏

可以通过管理后台添加测试游戏，建议包含以下信息：
- 游戏名称
- 游戏简介
- 游戏描述
- 分类
- 价格（免费游戏设为 0）
- 折扣（0-100）
- 开发商
- 发行商
- 封面图片
- 状态（上架/下架）

## 性能优化建议

1. **启用 Redis 缓存**
   - 游戏列表、详情等热点数据会自动缓存
   - 修改数据后缓存会自动更新

2. **数据库优化**
   - 定期清理无用数据
   - 监控慢查询日志
   - 根据需要添加索引

3. **前端优化**
   - 生产环境使用 `npm run build` 构建
   - 使用 Nginx 部署静态文件
   - 启用 Gzip 压缩

## 安全建议

1. **修改默认密码**
   - 立即修改 admin 账号密码
   - 使用强密码

2. **配置 HTTPS**
   - 生产环境必须使用 HTTPS
   - 可以使用 Let's Encrypt 免费证书

3. **定期备份**
   - 定期备份 MySQL 数据库
   - 备份重要文件

4. **监控日志**
   - 定期检查后端日志
   - 监控异常访问

## 技术支持

如遇到问题：
1. 查看本文档
2. 查看 README.md
3. 检查后端和前端日志
4. 提交 Issue 描述问题

祝使用愉快！
