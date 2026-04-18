-- 示例游戏数据
-- 用于测试的示例游戏

USE steam_mall;

-- 插入示例游戏数据
INSERT INTO `game` (`name`, `description`, `short_description`, `cover_image`, `banner_image`, `price`, `discount`, `developer`, `publisher`, `release_date`, `category`, `tags`, `status`, `view_count`, `sales_count`, `positive_reviews`, `negative_reviews`) VALUES
('赛博朋克 2077', '赛博朋克 2077 是一款开放世界动作冒险 RPG 游戏。故事发生在夜之城，这是一座五光十色的大都会，人们痴迷于力量、华丽和身体改造。', '开放世界动作冒险 RPG', '/images/cyberpunk-cover.jpg', '/images/cyberpunk-banner.jpg', 298.00, 65.00, 'CD Projekt Red', 'CD Projekt', '2020-12-10', '角色扮演', '赛博朋克，开放世界，角色扮演，科幻', 1, 15000, 500, 450, 50),

('星露谷物语', '你继承了爷爷在星露谷的农场。你带着二手工具和一袋种子开始了你的新生活。你的任务是让这片土地重新焕发生机。', '农场模拟 RPG', '/images/stardew-cover.jpg', '/images/stardew-banner.jpg', 48.00, 50.00, 'ConcernedApe', 'ConcernedApe', '2016-02-26', '模拟', '农场模拟，像素风格，生活模拟，休闲', 1, 20000, 800, 780, 20),

('艾尔登法环', '站起来，褪色者啊。让指引恩典带领你前进，揭露艾尔登法环的秘密，成为艾尔登之王。', '黑暗奇幻动作 RPG', '/images/eldenring-cover.jpg', '/images/eldenring-banner.jpg', 298.00, 0.00, 'FromSoftware', 'Bandai Namco', '2022-02-25', '角色扮演', '魂系，黑暗奇幻，开放世界，困难', 1, 25000, 1000, 950, 50),

('只狼：影逝二度', '在 1500 年代末的日本战国时代，一位名为狼的忍者发誓要拯救他被俘的主人。', '动作冒险游戏', '/images/sekiro-cover.jpg', '/images/sekiro-banner.jpg', 198.00, 30.00, 'FromSoftware', 'Activision', '2019-03-22', '动作', '魂系，忍者，困难，日本', 1, 18000, 600, 580, 20),

('巫师 3：狂猎', '作为巫师，一位猎杀怪物的雇佣法师，你要在道德和政治交织的复杂世界中寻找预言之子。', '开放世界 RPG', '/images/witcher3-cover.jpg', '/images/witcher3-banner.jpg', 158.00, 75.00, 'CD Projekt Red', 'CD Projekt', '2015-05-19', '角色扮演', '开放世界，奇幻，剧情丰富，选择驱动', 1, 30000, 1200, 1150, 50),

('荒野大镖客：救赎 2', '美国，1899 年。西部时代的终结。亚瑟·摩根和范德林德帮是被通缉的逃犯。', '开放世界动作冒险', '/images/rdr2-cover.jpg', '/images/rdr2-banner.jpg', 279.00, 50.00, 'Rockstar Games', 'Rockstar Games', '2019-12-05', '动作', '开放世界，西部，剧情丰富，写实', 1, 22000, 900, 870, 30),

('战神 4', '他的复仇之路已经结束。现在奎托斯必须为一个陌生的世界而战，那里充满了怪物、谜团和危险。', '动作冒险游戏', '/images/godofwar-cover.jpg', '/images/godofwar-banner.jpg', 279.00, 40.00, 'Santa Monica Studio', 'Sony', '2022-01-14', '动作', '神话，北欧神话，剧情丰富，单人', 1, 19000, 750, 720, 30),

('霍格沃茨之遗', '霍格沃茨之遗是一款基于哈利波特宇宙的动作 RPG，背景设定在 1800 年代。', '魔法世界 RPG', '/images/hogwarts-cover.jpg', '/images/hogwarts-banner.jpg', 299.00, 20.00, 'Avalanche Software', 'Warner Bros', '2023-02-10', '角色扮演', '魔法，哈利波特，开放世界，奇幻', 1, 28000, 1100, 1000, 100),

('上古卷轴 5：天际', '上古卷轴 V：天际重新定义了开放世界游戏的概念。', '开放世界 RPG', '/images/skyrim-cover.jpg', '/images/skyrim-banner.jpg', 99.00, 60.00, 'Bethesda', 'Bethesda', '2011-11-11', '角色扮演', '开放世界，奇幻，龙，经典', 1, 35000, 1500, 1450, 50),

('GTA V', '洛圣都，一个充满阳光和名人的 sprawling 城市。在这座城市中，一个年轻的街头混混被迫卷入地下犯罪世界。', '开放世界动作冒险', '/images/gtav-cover.jpg', '/images/gtav-banner.jpg', 199.00, 50.00, 'Rockstar North', 'Rockstar Games', '2015-04-14', '动作', '开放世界，犯罪，多人，喜剧', 1, 40000, 2000, 1900, 100),

('Apex 英雄', 'Apex Legends 是一款免费的大逃杀射击游戏，拥有传奇角色、团队玩法和创新的重生系统。', '免费大逃杀射击游戏', '/images/apex-cover.jpg', '/images/apex-banner.jpg', 0.00, 0.00, 'Respawn Entertainment', 'Electronic Arts', '2020-11-04', '多人', '大逃杀，免费开玩，射击，多人', 1, 50000, 0, 3000, 500),

('反恐精英 2', '二十多年来，Counter-Strike 提供了世界上最具竞争力的游戏体验。', '竞技射击游戏', '/images/cs2-cover.jpg', '/images/cs2-banner.jpg', 0.00, 0.00, 'Valve', 'Valve', '2023-09-27', '多人', '射击，竞技，多人，战术', 1, 60000, 0, 4000, 800);

-- 插入轮播图数据
INSERT INTO `carousel` (`title`, `image_url`, `target_type`, `target_id`, `sort_order`, `status`) VALUES
('赛博朋克 2077 - 限时特惠', '/images/carousel-cyberpunk.jpg', 'GAME', 1, 1, 1),
('艾尔登法环 - 年度最佳游戏', '/images/carousel-eldenring.jpg', 'GAME', 3, 2, 1),
('夏日特卖进行中', '/images/carousel-summer-sale.jpg', 'URL', NULL, 3, 1),
('霍格沃茨之遗 - 魔法世界等你探索', '/images/carousel-hogwarts.jpg', 'GAME', 8, 4, 1),
('免费开玩 - Apex 英雄', '/images/carousel-apex.jpg', 'GAME', 11, 5, 1);

-- 更新游戏图片为 JSON 数组
UPDATE `game` SET `images` = '["/images/game1-screenshot1.jpg", "/images/game1-screenshot2.jpg", "/images/game1-screenshot3.jpg"]' WHERE `id` = 1;
UPDATE `game` SET `images` = '["/images/game2-screenshot1.jpg", "/images/game2-screenshot2.jpg"]' WHERE `id` = 2;
UPDATE `game` SET `images` = '["/images/game3-screenshot1.jpg", "/images/game3-screenshot2.jpg", "/images/game3-screenshot3.jpg", "/images/game3-screenshot4.jpg"]' WHERE `id` = 3;

-- 插入系统需求示例
UPDATE `game` SET `system_requirements` = '最低配置:
操作系统：Windows 10 64-bit
处理器：Intel Core i5-3570K 或 AMD FX-8310
内存：8 GB RAM
显卡：NVIDIA GeForce GTX 780 或 AMD Radeon RX 470
DirectX 版本：12
存储空间：70 GB 可用空间

推荐配置:
操作系统：Windows 10 64-bit
处理器：Intel Core i7-4790 或 AMD Ryzen 3 3200G
内存：12 GB RAM
显卡：NVIDIA GeForce GTX 1060 或 AMD Radeon R9 Fury
DirectX 版本：12
存储空间：70 GB SSD' WHERE `id` = 1;

COMMIT;
