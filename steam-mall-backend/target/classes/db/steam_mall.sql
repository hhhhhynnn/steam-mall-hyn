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

 Date: 24/04/2026 20:28:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activation_code
-- ----------------------------
DROP TABLE IF EXISTS `activation_code`;
CREATE TABLE `activation_code`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expire_time` datetime(6) NULL DEFAULT NULL,
  `game_id` bigint(20) NOT NULL,
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint(20) NULL DEFAULT NULL,
  `status` int(11) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_8ajx3tnkbhwdupdh80igwbvol`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;


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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO `carousel` VALUES (1, '', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/6903f617-b5f1-4a2e-a520-1a15f9c3b0df.jpg', 'GAME', 17, '/game/17', 0, 1, '2026-04-19 21:23:02', '2026-04-19 21:23:02');
INSERT INTO `carousel` VALUES (2, '', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/d7bfd2c6-8763-4b65-9ed3-43be89a76cf0.jpg', 'GAME', 5, '/game/5', 2, 1, '2026-04-19 21:23:33', '2026-04-19 21:23:33');
INSERT INTO `carousel` VALUES (3, '', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9d4856db-45cb-4c33-bc97-e063a34a740e.jpg', 'GAME', 4, '/game/4', 3, 1, '2026-04-19 21:24:05', '2026-04-19 22:03:26');
INSERT INTO `carousel` VALUES (4, '', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/0f5dc795-8670-4321-90e7-b39cc319cc9d.jpg', 'GAME', 9, '/game/9', 4, 1, '2026-04-19 21:24:20', '2026-04-19 21:24:20');

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
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_sales`(`sales_count`) USING BTREE,
  INDEX `idx_rating_rank`(`status`, `positive_reviews`, `negative_reviews`) USING BTREE,
  FULLTEXT INDEX `idx_search`(`name`, `description`)
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏表' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for game_category
-- ----------------------------
DROP TABLE IF EXISTS `game_category`;
CREATE TABLE `game_category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类 ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game_category
-- ----------------------------
INSERT INTO `game_category` VALUES (1, '动作', 1, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (2, '冒险', 2, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (3, '策略', 3, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (4, '角色扮演', 4, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (5, '模拟', 5, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (6, '体育', 6, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (7, '竞速', 7, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (8, '独立', 8, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (9, '多人', 9, 1, '2026-03-21 01:47:56', NULL);
INSERT INTO `game_category` VALUES (10, '免费开玩', 10, 1, '2026-03-21 01:47:56', NULL);

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
  `status` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `helpful_count` int(11) NULL DEFAULT NULL,
  `play_hours` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_game_review`(`user_id`, `game_id`) USING BTREE,
  INDEX `idx_game_id`(`game_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  INDEX `idx_game_status_positive`(`game_id`, `status`, `is_positive`) USING BTREE,
  CONSTRAINT `fk_review_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏评价表' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for hot_sale
-- ----------------------------
DROP TABLE IF EXISTS `hot_sale`;
CREATE TABLE `hot_sale`  (
  `game_id` bigint(20) NOT NULL COMMENT '游戏 ID',
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '游戏封面图',
  `sales_count` bigint(20) NOT NULL DEFAULT 0 COMMENT '累计销量',
  `sales_amount` decimal(38, 2) NULL DEFAULT NULL COMMENT '展示价格',
  `rank` int(11) NOT NULL COMMENT '排名(1-10)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`game_id`) USING BTREE,
  UNIQUE INDEX `uk_hot_sale_rank`(`rank`) USING BTREE,
  INDEX `idx_rank`(`rank`) USING BTREE,
  CONSTRAINT `fk_hot_sale_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '热销榜表，仅保留当前前十' ROW_FORMAT = Dynamic;


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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;


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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;


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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户游戏库表' ROW_FORMAT = Dynamic;


SET FOREIGN_KEY_CHECKS = 1;
