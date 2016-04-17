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
    "user": {
        "username": "nightfade",
        "email": "nightfade@163.com",
        // TODO (zhangmeng): 补全其他用户信息
    },
    "token": "xxxxx",
    "expired_at": 1460351229
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

