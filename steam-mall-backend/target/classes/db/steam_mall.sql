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

 Date: 19/04/2026 22:08:36
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activation_code
-- ----------------------------
DROP TABLE IF EXISTS `activation_code`;
CREATE TABLE `activation_code`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `activated_at` datetime(6) NULL DEFAULT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `expire_time` datetime(6) NULL DEFAULT NULL,
  `game_id` bigint(20) NOT NULL,
  `game_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` bigint(20) NULL DEFAULT NULL,
  `status` int(11) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_8ajx3tnkbhwdupdh80igwbvol`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activation_code
-- ----------------------------
INSERT INTO `activation_code` VALUES (1, NULL, 'CFXR-PBEB-S23Q-UHV7', '2026-04-09 20:32:53.093803', '2036-04-09 20:32:53.093803', 5, '赛博朋克 2077', 1, 0, '2026-04-09 20:32:53.093803', NULL);
INSERT INTO `activation_code` VALUES (4, NULL, 'T7E3-RXKQ-EAEQ-Q3ED', '2026-04-18 22:41:51.916082', '2036-04-18 22:41:51.916082', 9, '巫师 3：狂猎', 6, 0, '2026-04-18 22:41:51.916082', NULL);
INSERT INTO `activation_code` VALUES (5, NULL, 'FTHJ-W2YJ-YYM2-QU3S', '2026-04-18 23:07:15.470786', '2036-04-18 23:07:15.470786', 15, 'Apex 英雄', 7, 0, '2026-04-18 23:07:15.470786', NULL);

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
  FULLTEXT INDEX `idx_search`(`name`, `description`, `tags`),
  INDEX `idx_rating_rank`(`status`, `positive_reviews`, `negative_reviews`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game
-- ----------------------------
INSERT INTO `game` VALUES (4, '艾尔登法环', '', '艾尔登法环是以正统黑暗奇幻世界为舞台的动作RPG游戏。 走进辽阔的场景与地下迷宫探索未知，挑战困难重重的险境，享受克服困境时的成就感吧。 不仅如此，登场角色之间的利害关系谱成的群像剧，更是不容错过。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9d4856db-45cb-4c33-bc97-e063a34a740e.jpg', '', 298.00, 0.00, 298.00, 'FromSoftware', 'Bandai Namco Entertainment', '2022-02-26', '角色扮演,冒险,动作', '', '', NULL, '', 1, 14, 0, 0, 0, '2026-03-21 12:23:41', '2026-04-19 22:03:00');
INSERT INTO `game` VALUES (5, '赛博朋克 2077', '赛博朋克 2077 是一款开放世界动作冒险 RPG 游戏。故事发生在夜之城，这是一座五光十色的大都会，人们痴迷于力量、华丽和身体改造。', '开放世界动作冒险 RPG', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/297cf394-edf0-4342-bdd4-da00ab4082e3.jpg', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/d7bfd2c6-8763-4b65-9ed3-43be89a76cf0.jpg', 298.00, 65.00, 104.30, 'CD Projekt Red', 'CD Projekt', '2020-12-10', '角色扮演,冒险,动作', '赛博朋克，开放世界，角色扮演，科幻', NULL, NULL, NULL, 1, 14, 3, 0, 0, '2026-04-01 22:45:48', '2026-04-19 21:45:46');
INSERT INTO `game` VALUES (6, '星露谷物语', '你继承了爷爷在星露谷的农场。你带着二手工具和一袋种子开始了你的新生活。你的任务是让这片土地重新焕发生机。', '农场模拟 RPG', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/f50873bb-704d-4daa-96ee-b3d123329692.jpg', '/images/stardew-banner.jpg', 48.00, 50.00, 24.00, 'ConcernedApe', 'ConcernedApe', '2016-02-26', '模拟,角色扮演', '农场模拟，像素风格，生活模拟，休闲', NULL, NULL, NULL, 1, 4, 1, 0, 0, '2026-04-01 22:45:48', '2026-04-19 21:45:53');
INSERT INTO `game` VALUES (8, '只狼：影逝二度', '在《Sekiro: Shadows Die Twice (只狼：影逝二度)》中你是“独臂之狼”，一个名誉不再、伤痕累累的忍者，一个从死亡边缘捡回一命的战士。你效忠守护继承古老血统的年轻皇子，与危险的苇名一族以及众多凶恶之徒为敌。年轻的皇子被抓走后，为挽回荣誉，你将不畏死亡，踏上危机四伏的征程。\n\n探索生死冲突不断的16世纪后期，感受残酷的日本战国时代，在黑暗、扭曲的世界，与威胁生命的敌人对峙。活用义手装备各种致命武器，大显忍者身手，在血腥对抗中潜行、上下穿梭，与敌人正面激烈交锋。\n\n复仇雪耻。夺回荣誉。巧妙杀敌。', '进入由打造了《黑暗之魂》系列的知名开发商FromSoftware倾力制作的全新冒险，用智慧和力量斩开复仇之路。 决死复仇，夺回荣誉，智杀强敌。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9c435e21-6736-4d40-abf3-8dc7163867eb.jpg', '/images/sekiro-banner.jpg', 198.00, 30.00, 138.60, 'FromSoftware', 'Activision', '2019-03-22', '动作,角色扮演,冒险', '魂系，忍者，困难，日本', NULL, NULL, NULL, 1, 3, 0, 0, 0, '2026-04-01 22:45:48', '2026-04-18 23:20:57');
INSERT INTO `game` VALUES (9, '巫师 3：狂猎', '作为巫师，一位猎杀怪物的雇佣法师，你要在道德和政治交织的复杂世界中寻找预言之子。', '您是利维亚的杰洛特，收钱办事的怪物杀手。您可以在眼前这片怪物横行、饱受战火摧残的土地上尽情探索。您手上的委托？追踪预言之子——希里，一件足以改变世界面貌的活生生的武器。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/83450d3e-31d0-47bb-a828-1c3c5b02e162.jpg', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/0f5dc795-8670-4321-90e7-b39cc319cc9d.jpg', 158.00, 75.00, 39.50, 'CD Projekt Red', 'CD Projekt', '2015-05-19', '角色扮演,冒险', '开放世界，奇幻，剧情丰富，选择驱动', NULL, NULL, NULL, 1, 2, 1, 0, 0, '2026-04-01 22:45:48', '2026-04-19 22:02:52');
INSERT INTO `game` VALUES (10, '荒野大镖客：救赎 2', '美国，1899 年。亚瑟·摩根和范德林德帮众是一群逃亡在外的亡命之徒。联邦侦探和全国顶尖的赏金猎人在他们的身后穷追不舍，亚瑟一行人必须在广袤蛮荒的美国腹地上四处劫掠、挣扎求生。而帮派内部的矛盾分化日渐加深，摆在亚瑟面前的将是他无法避免的抉择：究竟是选择自己的理想，还是选择效忠于抚养了自己的帮派。\n\nRed Dead Redemption 2 已荣获超过 175 项年度游戏奖项且获得超过 250 个满分评价，游戏以 19 世纪的最后岁月为背景，述说一个关于荣誉与忠诚的史诗故事。\n\nRed Dead Redemption 2 还包含 Red Dead 在线模式，一款以 Red Dead Redemption 2 生活世界为背景的多人游戏体验，玩家可以独自骑行或组建团队，酿造私酒，与执法人员、不法帮派和凶猛的野生动物战斗，在美洲边境开辟自己的道路。', '亚瑟·摩根和范德林德帮众是一群逃亡在外的亡命之徒。联邦侦探和赏金猎人在他们的身后穷追不舍，亚瑟一行人必须在广袤蛮荒的腹地上四处劫掠、挣扎求生。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/375fdfe4-5abf-4d7e-87ae-2a2664e693a5.jpg', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/a95839a9-a255-4502-b9a3-f32618d591f1.jpg', 279.00, 50.00, 139.50, 'Rockstar Games', 'Rockstar Games', '2019-12-05', '动作,角色扮演', '开放世界，西部，剧情丰富，写实', NULL, NULL, NULL, 1, 2, 0, 0, 0, '2026-04-01 22:45:48', '2026-04-18 23:20:59');
INSERT INTO `game` VALUES (15, 'Apex 英雄', 'Apex Legends 是一款免费的大逃杀射击游戏，拥有传奇角色、团队玩法和创新的重生系统。', '免费大逃杀射击游戏', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/357d8a08-728e-4793-a062-57fc94ccf143.jpg', '/images/apex-banner.jpg', 0.00, 0.00, 0.00, 'Respawn Entertainment', 'Electronic Arts', '2020-11-04', '多人,免费开玩', '大逃杀，免费开玩，射击，多人', NULL, NULL, NULL, 1, 4, 1, 0, 0, '2026-04-01 22:45:48', '2026-04-19 22:02:58');
INSERT INTO `game` VALUES (17, 'Resident Evil Requiem', '予生者恐惧。给尸者安魂。\n\n《Resident Evil Requiem》是开创生存恐怖新纪元的系列最新作。与FBI分析员格蕾丝一同体验令人战栗的恐惧，并与资深特工里昂一同感受战胜死亡的畅快感。双角色的游戏体验，以及围绕二人纵横交错的剧情，绝对能直击玩家的灵魂。', '予生者恐惧。给尸者安魂。 《Resident Evil Requiem》标志着“Resident Evil”系列和生存恐怖游戏步入新纪元。“安魂曲”将会撼动玩家的精神深处。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/6903f617-b5f1-4a2e-a520-1a15f9c3b0df.jpg', '', 348.00, 0.00, 348.00, 'Capcom', 'Capcom', '2026-02-26', '冒险,动作,角色扮演', '', '', NULL, '', 1, 13, 2, 1, 0, '2026-04-01 23:08:36', '2026-04-19 21:57:42');
INSERT INTO `game` VALUES (18, 'Pragmata', '“不管你去哪儿，我都会陪着你。”\n\n《Pragmata》是卡普空推出的一款独特的科幻动作冒险游戏。\n玩家将跟随命运多舛的调查队队员“休”和机器人小女孩“戴安娜”，在被失控AI掌管的\n月球设施内寻找返回地球的方法。\n■一场突如其来的事故，一对不同寻常的搭档\n\n人类在遥远的月球研究设施中，发现了一种新矿石。这种矿石经过精炼后可以用于3D打印\n机，再现出任何物体。\n\n在这座设施突然失联后，休跟随小队被派去调查……却遇到了一场灾难。\n\n独自徘徊在复杂设施中的人形机器人“戴安娜”救了休。二人必须合作才能穿过设施，找到\n离开月球的方法，但整座设施却被想阻止他们的AI所控制。', '《Pragmata》是卡普空推出的一款独特的科幻动作冒险游戏。 玩家将跟随命运多舛的调查队队员“休”和机器人小女孩“戴安娜”，在被失控AI掌管的月球设施内寻找返回地球的方法。', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/2a293b94-6753-4b71-9153-a6ef8fcdc30c.jpg', '', 248.00, 0.00, 248.00, 'CAPCOM', 'CAPCOM', '2026-04-16', '动作,冒险,角色扮演', '', '', NULL, '', 1, 1, 2, 1, 1, '2026-04-19 21:45:36', '2026-04-19 21:58:23');

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
  INDEX `idx_game_status_positive`(`game_id`, `status`, `is_positive`) USING BTREE,
  CONSTRAINT `fk_review_game` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of game_review
-- ----------------------------
INSERT INTO `game_review` VALUES (1, 2, 17, 1, '好玩', 0.00, 0, 1, '2026-04-19 21:53:00', '2026-04-19 21:53:00');
INSERT INTO `game_review` VALUES (2, 3, 18, 1, '强强', 0.00, 0, 1, '2026-04-19 21:57:32', '2026-04-19 21:57:32');
INSERT INTO `game_review` VALUES (3, 2, 18, 0, '流程太短', 0.00, 0, 1, '2026-04-19 21:58:23', '2026-04-19 21:58:23');

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
  `sales_amount` decimal(38, 2) NULL DEFAULT NULL,
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
) ENGINE = InnoDB AUTO_INCREMENT = 317 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '热销榜表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hot_sale
-- ----------------------------
INSERT INTO `hot_sale` VALUES (308, 5, '赛博朋克 2077', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/297cf394-edf0-4342-bdd4-da00ab4082e3.jpg', 3, 298.00, 1, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (309, 17, 'Resident Evil Requiem', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/6903f617-b5f1-4a2e-a520-1a15f9c3b0df.jpg', 2, 348.00, 2, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (310, 18, 'Pragmata', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/2a293b94-6753-4b71-9153-a6ef8fcdc30c.jpg', 2, 248.00, 3, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (311, 6, '星露谷物语', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/f50873bb-704d-4daa-96ee-b3d123329692.jpg', 1, 48.00, 4, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (312, 9, '巫师 3：狂猎', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/83450d3e-31d0-47bb-a828-1c3c5b02e162.jpg', 1, 158.00, 5, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (313, 15, 'Apex 英雄', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/357d8a08-728e-4793-a062-57fc94ccf143.jpg', 1, 0.00, 6, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (314, 4, '艾尔登法环', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9d4856db-45cb-4c33-bc97-e063a34a740e.jpg', 0, 298.00, 7, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (315, 8, '只狼：影逝二度', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/9c435e21-6736-4d40-abf3-8dc7163867eb.jpg', 0, 198.00, 8, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');
INSERT INTO `hot_sale` VALUES (316, 10, '荒野大镖客：救赎 2', 'https://hangyinengbishe.oss-cn-shanghai.aliyuncs.com/images/375fdfe4-5abf-4d7e-87ae-2a2664e693a5.jpg', 0, 279.00, 9, 'ALL', '2020-01-01', '2026-04-19 22:06:55', '2026-04-19 22:06:55');

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (1, 'ORD17757379730820827668E', 1, 5, '赛博朋克 2077', 104.30, 1, 'CFXR-PBEB-S23Q-UHV7', '2026-04-09 20:32:53', '2026-04-09 20:32:53', '2026-04-09 20:32:53');
INSERT INTO `order` VALUES (2, 'ORD1775737978193DFAFA308', 1, 5, '赛博朋克 2077', 104.30, 1, 'EEZK-4RHL-SHNA-HJNQ', '2026-04-09 20:32:58', '2026-04-09 20:32:58', '2026-04-09 20:32:58');
INSERT INTO `order` VALUES (3, 'ORD1775738954772FE3B7F04', 1, 6, '星露谷物语', 24.00, 1, 'YWLP-29WH-Q6C4-VKGK', '2026-04-09 20:49:15', '2026-04-09 20:49:15', '2026-04-09 20:49:15');
INSERT INTO `order` VALUES (4, 'ORD1775741701124CA903D19', 2, 5, '赛博朋克 2077', 104.30, 1, 'AKPQ-W78Y-MRGN-RMCQ', '2026-04-09 21:35:01', '2026-04-09 21:35:01', '2026-04-09 21:35:01');
INSERT INTO `order` VALUES (5, 'ORD177574172126287BC2707', 2, 17, 'Resident Evil Requiem', 348.00, 1, 'PPCB-6283-W6DS-34LN', '2026-04-09 21:35:21', '2026-04-09 21:35:21', '2026-04-09 21:35:21');
INSERT INTO `order` VALUES (6, 'ORD1776523311904CA3F4A37', 2, 9, '巫师 3：狂猎', 39.50, 1, 'T7E3-RXKQ-EAEQ-Q3ED', '2026-04-18 22:41:52', '2026-04-18 22:41:52', '2026-04-18 22:41:52');
INSERT INTO `order` VALUES (7, 'ORD17765248354635524EF25', 2, 15, 'Apex 英雄', 0.00, 1, 'FTHJ-W2YJ-YYM2-QU3S', '2026-04-18 23:07:15', '2026-04-18 23:07:15', '2026-04-18 23:07:15');
INSERT INTO `order` VALUES (8, 'ORD1776607022564DAB7643A', 3, 18, 'Pragmata', 248.00, 1, 'C7VV-V5W7-K8KX-B88C', '2026-04-19 21:57:03', '2026-04-19 21:57:03', '2026-04-19 21:57:03');
INSERT INTO `order` VALUES (9, 'ORD177660706149970F62064', 3, 17, 'Resident Evil Requiem', 348.00, 1, 'XD99-CAUK-26ZQ-E764', '2026-04-19 21:57:41', '2026-04-19 21:57:42', '2026-04-19 21:57:41');
INSERT INTO `order` VALUES (10, 'ORD1776607085407F17A104E', 2, 18, 'Pragmata', 248.00, 1, 'FXTJ-CAF7-4YSS-2DZ4', '2026-04-19 21:58:05', '2026-04-19 21:58:05', '2026-04-19 21:58:05');

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
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$ZJbWvsdSUN.yPCjj7Qbiw.j4cKwGcWVLM8IAbHIUA9FcL1K4cBFIC', 'admin@steammall.com', NULL, 'ADMIN', 1, '2026-03-21 01:47:56', '2026-03-21 02:14:13');
INSERT INTO `user` VALUES (2, 'h1n', '$2a$10$DlrQ3poBRMGNkr91iDvssOIkoQigD/Skw2pC7qXYAF0apRp8Q7Brm', '', NULL, 'USER', 1, '2026-03-21 02:04:19', '2026-03-21 02:04:19');
INSERT INTO `user` VALUES (3, 'h2n', '$2a$10$ZZhbQFJGmmIG/i.h8n8MIOCeMrHYh8S04a58QMZpAsXYuUbIMQi76', '123@123.com', NULL, 'USER', 1, '2026-04-01 22:32:44', '2026-04-01 22:32:44');

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
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户游戏库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_game
-- ----------------------------
INSERT INTO `user_game` VALUES (1, 1, 5, 'EEZK-4RHL-SHNA-HJNQ', 1, '2026-04-09 20:33:04', 0, '2026-04-09 20:33:04');
INSERT INTO `user_game` VALUES (2, 2, 5, 'AKPQ-W78Y-MRGN-RMCQ', 1, '2026-04-09 21:35:10', 0, '2026-04-09 21:35:10');
INSERT INTO `user_game` VALUES (3, 2, 17, 'PPCB-6283-W6DS-34LN', 1, '2026-04-09 21:35:55', 0, '2026-04-09 21:35:55');
INSERT INTO `user_game` VALUES (4, 1, 6, 'YWLP-29WH-Q6C4-VKGK', 1, '2026-04-18 22:33:43', 0, '2026-04-18 22:33:43');
INSERT INTO `user_game` VALUES (5, 3, 18, 'C7VV-V5W7-K8KX-B88C', 1, '2026-04-19 21:57:10', 0, '2026-04-19 21:57:10');
INSERT INTO `user_game` VALUES (6, 3, 17, 'XD99-CAUK-26ZQ-E764', 1, '2026-04-19 21:57:51', 0, '2026-04-19 21:57:51');
INSERT INTO `user_game` VALUES (7, 2, 18, 'FXTJ-CAF7-4YSS-2DZ4', 1, '2026-04-19 21:58:13', 0, '2026-04-19 21:58:13');

SET FOREIGN_KEY_CHECKS = 1;
