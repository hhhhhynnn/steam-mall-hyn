本系统采用前后端分离架构，安装与部署需分别配置数据库、后端服务与前端服务。

1．数据库系统安装与配置
（1）安装MySQL 8.0+数据库服务端，并确保服务已启动。
（2）创建数据库：登录 MySQL，执行CREATE DATABASE steam_mall DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;。
（3）初始化表结构与数据：在命令行中执行项目提供的数据库脚本：
mysql -u root -p steam_mall < steam-mall-backend/src/main/resources/db/steam_mall
(仅结构)，mysql -u root -p steam_mall <steam-mall-backend/src/main/resources/db/steam_mall_data.sql（可选，已导入示例数据）。
（4）修改后端配置文件steam-mall-backend/src/main/resources/application.yml，将数据库用户名和密码修改为本机 MySQL 的实际配置。
2．缓存系统安装与配置
（1）下载并安装 Redis 6.0+ 服务端。
（2）启动 Redis 服务，默认端口为 6379。
（3）在application.yml 中确认 Redis 的连接地址、端口及密码配置正确。
3．后端服务安装与部署
（1）确保本机已安装 JDK 17+ 并配置好JAVA_HOME环境变量。
（2）确保已安装Maven 3.6+。
（3）进入后端项目目录：cd steam-mall-backend。
（4）（可选）配置阿里云 OSS：在application.yml中填入您的阿里云 OSS AccessKey、SecretKey 及 Bucket 名称，用于图片和视频的存储。若不配置，可使用本地存储或跳过上传功能。
（5）启动后端服务：执行命令mvn spring-boot:run。
（6）启动成功后，后端服务默认运行在http://localhost:8081。
4．前端服务安装与部署
（1）确保本机已安装 Node.js 18+。
（2）进入前端项目目录：cd steam-mall-frontend。
（3）安装前端依赖包：执行命令npm install。
（4）启动前端开发服务器：执行命令npm run dev。
（5）启动成功后，前端页面默认运行在 http://localhost:5173。
