@echo off
chcp 65001 >nul
echo ========================================
echo     仿 Steam 商城项目 - 快速启动脚本
echo ========================================
echo.

REM 检查 Java 环境
echo [1/5] 检查 Java 环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Java 环境，请先安装 JDK 17+
    pause
    exit /b 1
)
echo [成功] Java 环境检查通过
echo.

REM 检查 Node.js 环境
echo [2/5] 检查 Node.js 环境...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未检测到 Node.js 环境，请先安装 Node.js 18+
    pause
    exit /b 1
)
echo [成功] Node.js 环境检查通过
echo.

REM 检查 MySQL 环境
echo [3/5] 检查 MySQL 环境...
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未检测到 MySQL 命令行工具，请确保 MySQL 已启动
    echo [提示] 如果 MySQL 已启动，可以忽略此警告
) else (
    echo [成功] MySQL 环境检查通过
)
echo.

REM 检查 Redis 环境
echo [4/5] 检查 Redis 环境...
redis-cli ping >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] Redis 未启动，请确保 Redis 服务正在运行
    echo [提示] Windows 可使用 redis-server.exe 启动 Redis
) else (
    echo [成功] Redis 环境检查通过
)
echo.

echo [5/5] 开始启动服务...
echo.

REM 启动后端
echo [后端] 正在启动 Spring Boot 后端服务...
start "Steam Mall Backend" cmd /k "cd steam-mall-backend && mvn spring-boot:run"
echo [后端] 后端服务启动中...（约 30-60 秒）
echo.

REM 等待后端启动
timeout /t 10 /nobreak >nul

REM 启动前端
echo [前端] 正在启动 Vue 前端服务...
start "Steam Mall Frontend" cmd /k "cd steam-mall-frontend && npm run dev"
echo [前端] 前端服务启动中...
echo.

echo ========================================
echo     服务启动完成！
echo ========================================
echo.
echo 后端地址：http://localhost:8080
echo 前端地址：http://localhost:5173
echo.
echo 管理员账号:
echo   用户名：admin
echo   密码：admin123
echo.
echo 按任意键退出此窗口...
pause >nul
