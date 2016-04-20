# 注册 & 登录

## `POST /api/v1/user/register`

### 状态：已实现

### Request
```json
{
    "username": "nightfade",
    "email": "nightfade@163.com",
    "password": "123456"
}
```

### Response
```json
{
    "code": 0,
    "msg": "success",
    "token": "xxxx",
    "expired_at": 1460351229
}
```

## `POST /api/v1/user/login`

### 状态：已实现 TODO(zhangmeng): Response待完善

### Request

用户名密码登录：

```json
{
    "email": "nightfade@163.com",
    "password": "123456"
}
```

Token登录：

```json
{
    "token": "xxxx"
}
```

### Response
登录成功：

```json
{
    "code": 0,
    "auth": "token_xxxxx",
    /* TODO(zhangmeng): 以下字段暂未实现
    "expired_at": 1460351229,
    "user": {
        "username": "nightfade",
        "email": "nightfade@163.com",
        // TODO (zhangmeng): 补全其他用户信息
    },
    */
}
```

登录失败：

```json
{
    "code": -1,
    "msg": "密码错误"
}
```

## `POST /api/v1/user/oauth/login`

// TODO (zhangmeng): 待定


# 世界模块

### 状态：待实现者确认&修改

## `GET /api/v1/world/mapid`

### Request

```json
{
    "longitude": 123.43,
    "latitude": 567.82
}
```

### Response

```json
{
    "mapid": "xxx"
}
```

## `GET /api/v1/world/map`

### 状态：待实现者确认&修改

### Request

```json
{
    "mapid": "xxx",
    "updated_at": 1460351229
}
```

### Response

```json
{
    "mapid": "xxx",
    // optional，根据request里的updated_at，看地图是否更新过
    "url": "http://xxx.qiniu.com/xxx",  // 考虑地图使用七牛云存储
    "width": 300,
    "height": 400,
    "anchors": [
        {
            "x": 123,
            "y": 456,
            "anchor_id": "anchor_123"
        },
        {
            "x": 321,
            "y": 231,
            "anchor_id": "anchor_324"
        }
    ],
    "updated_at": 1460351229
}
```

## "GET /api/v1/world/anchor"

### 状态：待实现者确认&修改

### Request

```json
{
    "anchor_id": "anchor_123"
}
```

### Response

```json
{
    "anchor_id": "anchor_123",
    "data": {
        // TODO (zhangmeng): 根据anchor触发的行为，待定
    }
}
```

## "GET /api/v1/world/acquired"

### 状态：待实现者确认&修改

### Request

```json
{
    "token": "user_1234xxx"
}
```

### Response

成功：

```json
{
    "acquired_maps": [
        {
            "mapid": "map_123",
            "map_name": "这个地图",
            "map_icon_url": "http://xxx.aaa.xx"
        },
        {
            "mapid": "map_345",
            "map_name": "又一个地图",
            "map_icon_url": "http://www.aa.xx"
        },
    ]
}
```

失败：

```json
{
    "code": -1,
    "msg": "token过期，请重新登录"
}
```

# 故事模块

## `GET /api/v1/story/list`

### 状态：待实现者确认&修改

### Request

```json
{
    "start_ts": "1460351229",
    "limit": 10,
}
```

### Response

成功：

```json
{
    "code": 0,
    "stories": [
        {
            "story_id": "story_1234",
            "ts": 1460351229,
            "img_url": "http://xxx.xxx.xxx",
            "time": 120,
            "heart": 243,
            "distance": 5.1,
        },
        {
            "story_id": "story_3345",
            "ts": 1460351229,
            "img_url": "http://xxx.xxx.xxx",
            "time": 120,
            "heart": 243,
            "distance": 5.1,
        }
    ]
}
```

失败：

```json
{
    "code": -1,
    "msg": "获取失败"
}
```

## `GET /api/v1/story/detail`

### 状态：待实现者确认&修改

### Request

```json
{
    "story_id": "story_3322",
    "token": "user_xxxx",
}
```

### Response

成功：

```json
{
    "code": 0,
    "story": {
        "story_id": "story_3222",
        "img_urls": [
            "http://www.xxx.xxx",
        ],
        "hardness": 4,
        "description": "城市中有一群漫步者，你便是其中之一，故事从此开始…",
        "tags": ["美食", "运动", "小游戏", "人物", "室外"],
        "current_step": 3,
        "total_step": 10,
        "steps": [
            {
                "type": "video",
                "url": "http://www.xxx.xxx/a.mp4",
            },
            {
                "type": "number",
                "description": "门口的白猫叫了三声，老板盯着锅里的鸡爪抽了口烟，门口的门牌号快掉了，写着",
                "head_img_url": "http://xxx.xxx.xxx",
                "question": "249",
                "index": 1,
                "answer": "239",
            },
            {
                "type": "text",
                "description": "白猫跳到了桌上，这里要填空 _",
                "img_url": "http://www.xxx.xxx",
                "answer": "这是填空的答案",
            },
        ],
        "awards": [
            {
                "type": "coin",
                "amount": "100",
            },
            {
                "type": "coupon",
                "benefits": [
                    {
                        "title": "现金折扣 八五折",
                        "description": "持本券即可获得付款八五折优惠，同时可与其他折扣同时使用"
                    },
                    {
                        "title": "附赠小食",
                        "description": "获得小食一碟，具体到店酌情而定"
                    }
                ]
            }
        ]
    }
}
```

失败：

```json
{
    "code": -1,
    "msg": "登录过期，请重新登录"
}
```

# Map

## 获取最近未完成地图
### Request
```http
GET /api/v1/map/nearest/
Authorization: Token xxxxxxx

{
    "longitude": 114.06667,
    "latitude": 22.61667
}
```
### Response
```http
{
    "code": 0,
    "map": {
        "id": 1,
        "name": "Map-Name-1",
        "desc": "Map-Desc-1",
        "image_url": "http://example.com/map-1.png",
        "completed": false
    }
}
```

## 获取用户已获得地图列表
### Request
```http
GET /api/v1/map/acquired/
Authorization: Token xxxxxxx
```
### Response
```http
{
    "code": 0,
    "maps": [
        {
            "id": 1,
            "name": "Map-Name-1",
            "desc": "Map-Desc-1",
            "image_url": "http://example.com/map-1.png",
            "completed": false
        }
    ]
}
```

## 获取地图锚点列表
### Request
```http
GET /api/v1/map/1/anchor/
Authorization: Token xxxxxxx
```
### Response
```http
{
    "code": 0,
    "anchors": [
        {
            "id": 1,
            "name": "Anchor-Name-1",
            "dw": 10,
            "dh": 20,
            "type": "task",
            "ref_id": 1
        },
        {
            "id": 2,
            "name": "Anchor-Name-2",
            "dw": 50,
            "dh": 80,
            "type": "story",
            "ref_id": 1
        }
    ]
}
```

## 完成地图
### Request
```http
POST /api/v1/map/1/complete/
Authorization: Token xxxxxxx

{
    // TODO(stareven): encrypt
    // "key": "xxxxxxx"
}
```
### Response
```http
{
    "code": 0,
    "awards": [
        {
            "type": "medal",
            "detail": {
                "id": 1,
                "name": "Medal-Name-1",
                "desc": "Medal-Desc-1",
                "icon_url": "http://example.com/medal-1.png"
            }
        }
    ]
}
```

# Task

## 获取选择题组详情
### Request
```http
GET /api/v1/task/1/
Authorization: Token xxxxxxx
```
### Response
```http

{
    "code": 0,
    "task": {
        "id": 1,
        "name": "Task-Name-1",
        "desc": "Task-Desc-1",
        "completed": false,
        "choices": [
            {
                "id": 1,
                "task": 1,
                "order": 1,
                "name": "Choice-Name-1",
                "desc": "Choice-Desc-1",
                "image_url": "http://example.com/choice-1.png",
                // TODO(stareven): encrypt
                "answer": 1,
                "options": [
                    {
                        "id": 1,
                        "choice": 1,
                        "order": 1,
                        "desc": "Option-1"
                    }
                ]
            }
        ]
    }
}
```

## 完成选择题组
### Request
```http
POST /api/v1/task/1/complete/
Authorization: Token xxxxxxx

{
    // TODO(stareven): encrypt
    // "key": "xxxxxxx"
}
```
### Response
```http
{
    "code": 0,
    "awards": [
        {
            "type": "coin",
            "detail": {
                "amount": 100
            }
        }
    ]
}
```

# Story

## 获取所在城市故事列表
### Request
```http
GET /api/vi/story/current_city/
Authorization: Token xxxxxxx

{
    "longitude": 114.06667,
    "latitude": 22.61667
}
```
### Response
```http
{
    "code": 0,
    "city": "SZ",
    "stories": [
        {
            "id": 1,
            "name": "Story-Name-1",
            "desc": "Story-Desc-1",
            "image_urls": [
                "http://example.com/story-1-1.png",
                "http://example.com/story-1-2.png",
            ],
            "time": 120,
            "distance": 5.1,
            "like": 237,
            "level_ids": [1, 4, 3, 2],
            "city": "SZ"
        }
    ]
}
```

## 获取故事详情
### Request
```http
GET /api/v1/story/1/
Authorization: Token xxxxxxx
```
### Response
```http
{
    "code": 0,
    "story": {
        // TODO(stareven): complete
    }
}
```

## 完成故事关卡
### Request
```http
POST /api/v1/story/1/level/3/complete/
Authorization: Token xxxxxxx

{
    // TODO(stareven): encrypt
    // "key": "xxxxxxx"
}
```
### Response
```http
{
    "code": 0,
    "awards": [
        {
            "type": "coupon",
            "detail": {
                // TODO(stareven): complete
            }
        }
    ]
}
```

## 完成故事
### Request
```http
POST /api/v1/story/1/complete/
Authorization: Token xxxxxxx

{
    // TODO(stareven): encrypt
    // "key": "xxxxxxx"
}
```
### Response
```http
{
    "code": 0,
    "awards": [
        {
            "type": "coin",
            "detail": {
                "amount": 100
            }
        }
    ]
}
```
