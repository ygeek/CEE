INSERT INTO api_map(`id`, `name`, `desc`, `longitude`, `latitude`, `geohash`, `image_url`, `city_id`) VALUES
(1, 'Map-1', 'Map-Desc-1', 114.06667, 22.61667, 'ws10ethzdhcg', 'http://example.com/map-1.png', '300210000'),
(2, 'Map-2', 'Map-Desc-2', 114.06663, 22.61667, 'ws10ethz9hgg', 'http://example.com/map-2.png', '300210000'),
(3, 'Map-3', 'Map-Desc-3', 114.06663, 22.61667, 'ws10ethz9hgg', 'http://example.com/map-3.png', '300210000');
INSERT INTO api_medal(`id`, `name`, `desc`, `icon_url`, `map_id`) VALUES
(1, 'Medal-1', 'Medal-Desc-1', 'http://example.com/medal-1.png', 1),
(2, 'Medal-2', 'Medal-Desc-2', 'http://example.com/medal-2.png', 2);
INSERT INTO api_anchor(`id`, `name`, `dx`, `dy`, `type`, `ref_id`, `map_id`) VALUES
(1, 'Anchor-1', 23, 78, 'task', 1, 1),
(2, 'Anchor-2', 123, 4, 'story', 1, 1);
INSERT INTO api_task(`id`, `name`, `desc`, `coin`) VALUES
(1, 'Task-1', 'Task-Desc-1', 100);
INSERT INTO api_choice(`id`, `order`, `name`, `desc`, `image_url`, `answer`, `task_id`) VALUES
(1, 1, 'Choice-1', 'Choice-Desc-1', 'http://example.com/choice-1.png', 2, 1);
INSERT INTO api_option(`id`, `order`, `desc`, `choice_id`) VALUES
(1, 1, 'Option-Desc-1', 1),
(2, 2, 'Option-Desc-2', 1);
INSERT INTO api_story(`id`, `name`, `desc`, `time`, `good`, `distance`, `coin`, `image_urls`, `tour_url`, `city_id`) VALUES
(1, 'Story-1', 'Story-Desc-1', 45, 213, 5.1, 120, '["http://example.com/story-1-1.png", "http://example.com/story-1-2.png"]', 'http://example.com/story-tour-1.png', '300210000');
INSERT INTO api_level(`id`, `name`, `content`) VALUES
(1, 'Level-1', '{"type": "empty"}'),
(2, 'Level-2', '{"type": "empty"}');
INSERT INTO api_item(`id`, `name`, `activate_at`, `content`) VALUES
(1, 'Item-1', 1, '{"type": "empty"}'),
(2, 'Item-2', 2, '{"type": "empty"}');
INSERT INTO api_coupon(`id`, `name`, `desc`, `gmt_start`, `gmt_end`, `code`, `is_deleted`) VALUES
(1, 'Coupon-1', '{"info": []}', '2016-04-30', '2016-05-30', '1234', 0),
(2, 'Coupon-2', '{"info": []}', '2016-04-30', '2016-05-30', '1234', 0),
(3, 'Coupon-3', '{"info": []}', '2016-04-30', '2016-05-30', '1234', 0);
INSERT INTO api_storylevel(`id`, `order`, `level_id`, `story_id`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 1);
INSERT INTO api_storyitem(`id`, `item_id`, `story_id`) VALUES
(1, 1, 1),
(2, 2, 1);
INSERT INTO api_levelcoupon(`id`, `amount`, `remain`, `coupon_id`, `level_id`, `story_id`) VALUES
(1, 10, 10, 1, 1, 1),
(2, 10, 0, 2, 1, 1),
(3, 10, 10, 2, 2, 1);
