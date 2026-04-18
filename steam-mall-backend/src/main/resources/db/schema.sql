-- 创建数据库
CREATE DATABASE IF NOT EXISTS steam_mall DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE steam_mall;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户 ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码 (加密)',
    `email` VARCHAR(100) UNIQUE COMMENT '邮箱',
    `avatar` VARCHAR(255) COMMENT '头像 URL',
    `role` VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色：ADMIN/USER',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_username` (`username`),
    INDEX `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 游戏表
CREATE TABLE IF NOT EXISTS `game` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '游戏 ID',
    `name` VARCHAR(200) NOT NULL COMMENT '游戏名称',
    `description` TEXT COMMENT '游戏描述',
    `short_description` VARCHAR(500) COMMENT '游戏简介',
    `cover_image` VARCHAR(255) COMMENT '封面图片 URL',
    `banner_image` VARCHAR(255) COMMENT '横幅图片 URL',
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格',
    `discount` DECIMAL(5,2) DEFAULT 0.00 COMMENT '折扣百分比 (0-100)',
    `final_price` DECIMAL(10,2) COMMENT '折后价格',
    `developer` VARCHAR(100) COMMENT '开发商',
    `publisher` VARCHAR(100) COMMENT '发行商',
    `release_date` DATE COMMENT '发布日期',
    `category` VARCHAR(50) COMMENT '游戏分类',
    `tags` VARCHAR(500) COMMENT '标签 (逗号分隔)',
    `video_url` VARCHAR(255) COMMENT '宣传视频 URL',
    `images` TEXT COMMENT '游戏截图 (JSON 数组)',
    `system_requirements` TEXT COMMENT '系统需求',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    `view_count` BIGINT DEFAULT 0 COMMENT '浏览次数',
    `sales_count` BIGINT DEFAULT 0 COMMENT '销量',
    `positive_reviews` INT DEFAULT 0 COMMENT '好评数',
    `negative_reviews` INT DEFAULT 0 COMMENT '差评数',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_name` (`name`),
    INDEX `idx_category` (`category`),
    INDEX `idx_status` (`status`),
    INDEX `idx_sales` (`sales_count`),
    FULLTEXT INDEX `idx_search` (`name`, `description`, `tags`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏表';

-- 用户游戏库表
CREATE TABLE IF NOT EXISTS `user_game` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    `user_id` BIGINT NOT NULL COMMENT '用户 ID',
    `game_id` BIGINT NOT NULL COMMENT '游戏 ID',
    `activation_code` VARCHAR(100) NOT NULL UNIQUE COMMENT '激活密令',
    `is_activated` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已激活：0-否，1-是',
    `activated_at` DATETIME COMMENT '激活时间',
    `play_time` BIGINT DEFAULT 0 COMMENT '游戏时长 (分钟)',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY `uk_user_game` (`user_id`, `game_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_game_id` (`game_id`),
    INDEX `idx_activation_code` (`activation_code`),
    CONSTRAINT `fk_user_game_user` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_user_game_game` FOREIGN KEY (`game_id`) REFERENCES `game`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户游戏库表';

-- 订单表
CREATE TABLE IF NOT EXISTS `order` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单 ID',
    `order_no` VARCHAR(100) NOT NULL UNIQUE COMMENT '订单号',
    `user_id` BIGINT NOT NULL COMMENT '用户 ID',
    `game_id` BIGINT NOT NULL COMMENT '游戏 ID',
    `game_name` VARCHAR(200) NOT NULL COMMENT '游戏名称 (冗余)',
    `amount` DECIMAL(10,2) NOT NULL COMMENT '订单金额',
    `payment_status` TINYINT NOT NULL DEFAULT 0 COMMENT '支付状态：0-未支付，1-已支付，2-已取消',
    `activation_code` VARCHAR(100) COMMENT '激活密令',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `paid_at` DATETIME COMMENT '支付时间',
    INDEX `idx_order_no` (`order_no`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_created_at` (`created_at`),
    CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_game` FOREIGN KEY (`game_id`) REFERENCES `game`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单表';

-- 游戏评价表
CREATE TABLE IF NOT EXISTS `game_review` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评价 ID',
    `user_id` BIGINT NOT NULL COMMENT '用户 ID',
    `game_id` BIGINT NOT NULL COMMENT '游戏 ID',
    `is_positive` TINYINT NOT NULL COMMENT '是否好评：0-差评，1-好评',
    `content` TEXT COMMENT '评价内容',
    `play_hours` DECIMAL(10,2) DEFAULT 0 COMMENT '游戏时长 (小时)',
    `helpful_count` INT DEFAULT 0 COMMENT '有帮助数',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-显示',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY `uk_user_game_review` (`user_id`, `game_id`),
    INDEX `idx_game_id` (`game_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_created_at` (`created_at`),
    CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_game` FOREIGN KEY (`game_id`) REFERENCES `game`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏评价表';

-- 游戏分类表
CREATE TABLE IF NOT EXISTS `game_category` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '分类 ID',
    `name` VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    `icon` VARCHAR(255) COMMENT '分类图标',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='游戏分类表';

-- 轮播图表
CREATE TABLE IF NOT EXISTS `carousel` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '轮播图 ID',
    `title` VARCHAR(200) COMMENT '标题',
    `image_url` VARCHAR(255) NOT NULL COMMENT '图片 URL',
    `target_type` VARCHAR(20) COMMENT '目标类型：GAME/CATEGORY/URL',
    `target_id` BIGINT COMMENT '目标 ID(游戏 ID 或分类 ID)',
    `target_url` VARCHAR(255) COMMENT '目标 URL',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX `idx_status_sort` (`status`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='轮播图表';

-- 插入默认数据

-- 插入超级管理员账号 (密码：admin123, BCrypt 加密)
INSERT INTO `user` (`username`, `password`, `email`, `role`, `status`) 
VALUES ('admin', '$2a$10$N.zmdr9k79OCcU.mHtqLZ.r3lZ8qJN5qKjPvqKJZ9vKJZ9vKJZ9vK', 'admin@steammall.com', 'ADMIN', 1);

-- 插入游戏分类
INSERT INTO `game_category` (`name`, `icon`, `sort_order`, `status`) VALUES
('动作', '/icons/action.png', 1, 1),
('冒险', '/icons/adventure.png', 2, 1),
('策略', '/icons/strategy.png', 3, 1),
('角色扮演', '/icons/rpg.png', 4, 1),
('模拟', '/icons/simulation.png', 5, 1),
('体育', '/icons/sports.png', 6, 1),
('竞速', '/icons/racing.png', 7, 1),
('独立', '/icons/indie.png', 8, 1),
('多人', '/icons/multiplayer.png', 9, 1),
('免费开玩', '/icons/free.png', 10, 1);
