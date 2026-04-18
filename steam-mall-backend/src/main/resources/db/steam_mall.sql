/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50722 (5.7.22-log)
 Source Host           : localhost:3306
 Source Schema         : steam_mall

 Target Server Type    : MySQL
 Target Server Version : 50722 (5.7.22-log)
 File Encoding         : 65001

 Date: 31/03/2026 22:26:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '轮播图 ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片 URL',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标类型：GAME/CATEGORY/URL',
  `target_id` bigint(20) NULL DEFAULT NULL COMMENT '目标 ID(游戏 ID 或分类 ID)',
  `target_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标 URL',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel
-- ----------------------------

-- ----------------------------
-- Table structure for game
-- ----------------------------
DROP TABLE IF EXISTS `game`;
CREATE TABLE `game`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '游戏 ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '游戏描述',
  `short_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '游戏简介',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片 URL',
  `banner_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '横幅图片 URL',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格',
  `discount` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '折扣百分比 (0-100)',
  `final_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '折后价格',
  `developer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开发商',
  `publisher` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发行商',
  `release_date` date NULL DEFAULT NULL COMMENT '发布日期',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '游戏分类',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签 (逗号分隔)',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '宣传视频 URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '游戏截图 (JSON 数组)',
  `system_requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '系统需求',
  `status` int(11) NOT NULL,
  `view_count` bigint(20) NULL DEFAULT 0 COMMENT '浏览次数',
  `sales_count` bigint(20) NULL DEFAULT 0 COMMENT '销量',
  `positive_reviews` int(11) NULL DEFAULT 0 COMMENT '好评数',
  `negative_reviews` int(11) NULL DEFAULT 0 COMMENT '差评数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_sales`(`sales_count`) USING BTREE,
  FULLTEXT INDEX `idx_search`(`name`, `description`, `tags`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game
-- ----------------------------
INSERT INTO `game` VALUES (1, '1', '', '', '', '', 1.00, 0.00, 1.00, '12', '12', '2026-03-22', '动作', '', '', NULL, '', 1, 1, 0, 0, 0, '2026-03-21 12:04:50', '2026-03-31 21:17:07');
INSERT INTO `game` VALUES (2, '1', '', '', '', '', 1.00, 0.00, 1.00, '12', '12', '2026-03-22', '动作', '', '', NULL, '', 1, 0, 0, 0, 0, '2026-03-21 12:05:29', '2026-03-21 12:05:29');
INSERT INTO `game` VALUES (3, '1', '', '', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/56cb505f-3b3b-4027-a8c8-cfd3d8a88385.jpg', '', 1.00, 0.00, 1.00, '12', '12', '2026-03-22', '动作', '', '', NULL, '', 1, 0, 0, 0, 0, '2026-03-21 12:08:21', '2026-03-21 13:05:19');
INSERT INTO `game` VALUES (4, '艾尔登法环', '', '艾尔登法环是以正统黑暗奇幻世界为舞台的动作RPG游戏。 走进辽阔的场景与地下迷宫探索未知，挑战困难重重的险境，享受克服困境时的成就感吧。 不仅如此，登场角色之间的利害关系谱成的群像剧，更是不容错过。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9d4856db-45cb-4c33-bc97-e063a34a740e.jpg', '', 298.00, 0.00, 298.00, 'fromsoftware', 'bandai', '2022-02-26', '角色扮演', '', '', NULL, '', 1, 9, 0, 0, 0, '2026-03-21 12:23:41', '2026-03-21 13:25:36');

-- ----------------------------
-- Table structure for game_category
-- ----------------------------
DROP TABLE IF EXISTS `game_category`;
CREATE TABLE `game_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类图标',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game_category
-- ----------------------------
INSERT INTO `game_category` VALUES (1, '动作', '/icons/action.png', 1, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (2, '冒险', '/icons/adventure.png', 2, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (3, '策略', '/icons/strategy.png', 3, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (4, '角色扮演', '/icons/rpg.png', 4, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (5, '模拟', '/icons/simulation.png', 5, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (6, '体育', '/icons/sports.png', 6, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (7, '竞速', '/icons/racing.png', 7, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (8, '独立', '/icons/indie.png', 8, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (9, '多人', '/icons/multiplayer.png', 9, 1, '2026-03-21 01:47:56');
INSERT INTO `game_category` VALUES (10, '免费开玩', '/icons/free.png', 10, 1, '2026-03-21 01:47:56');

-- ----------------------------
-- Table structure for game_review
-- ----------------------------
DROP TABLE IF EXISTS `game_review`;
CREATE TABLE `game_review`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评价 ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户 ID',
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `is_positive` int(11) NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '评价内容',
  `play_hours` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '游戏时长 (小时)',
  `helpful_count` int(11) NULL DEFAULT 0 COMMENT '有帮助数',
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_game_review`(`user_id`, `game_id`) USING BTREE,
  INDEX `idx_game_id`(`game_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  CONSTRAINT `fk_review_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game_review
-- ----------------------------

-- ----------------------------
-- Table structure for hot_sale
-- ----------------------------
DROP TABLE IF EXISTS `hot_sale`;
CREATE TABLE `hot_sale`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录 ID',
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称 (冗余)',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '游戏封面图',
  `sales_count` bigint(20) NOT NULL DEFAULT 0 COMMENT '销量',
  `sales_amount` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '销售额',
  `rank` int(11) NOT NULL COMMENT '排名 (1-10)',
  `period_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL' COMMENT '统计周期：DAILY/WEEKLY/MONTHLY/ALL',
  `stat_date` date NOT NULL COMMENT '统计日期',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_game_period_date`(`game_id`, `period_type`, `stat_date`) USING BTREE,
  INDEX `idx_game_id`(`game_id`) USING BTREE,
  INDEX `idx_rank`(`rank`) USING BTREE,
  INDEX `idx_period_type`(`period_type`) USING BTREE,
  INDEX `idx_stat_date`(`stat_date`) USING BTREE,
  CONSTRAINT `fk_hot_sale_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '热销榜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hot_sale
-- ----------------------------

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单 ID',
  `order_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单号',
  `user_id` bigint(20) NOT NULL COMMENT '用户 ID',
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称 (冗余)',
  `amount` decimal(10, 2) NOT NULL COMMENT '订单金额',
  `payment_status` int(11) NOT NULL,
  `activation_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '激活密令',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `paid_at` datetime NULL DEFAULT NULL COMMENT '支付时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `order_no`(`order_no`) USING BTREE,
  INDEX `idx_order_no`(`order_no`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  INDEX `fk_order_game`(`game_id`) USING BTREE,
  CONSTRAINT `fk_order_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车 ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户 ID',
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称 (冗余)',
  `price` decimal(10, 2) NOT NULL COMMENT '加入购物车时的价格',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_game`(`user_id`, `game_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_game_id`(`game_id`) USING BTREE,
  CONSTRAINT `fk_cart_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码 (加密)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像 URL',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER' COMMENT '角色：ADMIN/USER',
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$ZJbWvsdSUN.yPCjj7Qbiw.j4cKwGcWVLM8IAbHIUA9FcL1K4cBFIC', 'admin@steammall.com', NULL, 'ADMIN', 1, '2026-03-21 01:47:56', '2026-03-21 02:14:13');
INSERT INTO `user` VALUES (2, 'h1n', '$2a$10$DlrQ3poBRMGNkr91iDvssOIkoQigD/Skw2pC7qXYAF0apRp8Q7Brm', '', NULL, 'USER', 1, '2026-03-21 02:04:19', '2026-03-21 02:04:19');

-- ----------------------------
-- Table structure for user_game
-- ----------------------------
DROP TABLE IF EXISTS `user_game`;
CREATE TABLE `user_game`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户 ID',
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `activation_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '激活密令',
  `is_activated` int(11) NOT NULL,
  `activated_at` datetime NULL DEFAULT NULL COMMENT '激活时间',
  `play_time` bigint(20) NULL DEFAULT 0 COMMENT '游戏时长 (分钟)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `activation_code`(`activation_code`) USING BTREE,
  UNIQUE INDEX `uk_user_game`(`user_id`, `game_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_game_id`(`game_id`) USING BTREE,
  INDEX `idx_activation_code`(`activation_code`) USING BTREE,
  CONSTRAINT `fk_user_game_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_game_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户游戏库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_game
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
