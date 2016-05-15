# -*- coding: utf-8 -*-

from __future__ import unicode_literals
from __future__ import absolute_import

import json
import requests

from .config import LeanCloudConfig, WeixinConfig, QQConfig, WeiboConfig


def broadcast_apns_notification(message, is_prod=True):
    payload = {
        'prod': 'prod' if is_prod else 'dev',
        'data': {
            'alert': message,
            'badge': 'Increment',
            # 'custom-key': '由用户添加的自定义属性，custom-key 仅是举例，可随意替换',
        },
    }
    _post_apns_payload(payload)


def push_apns_notification(message, device_token, is_prod=True):
    payload = {
        'prod': 'prod' if is_prod else 'dev',
        'data': {
            'alert': message,
            'badge': 'Increment',
            # 'custom-key': '由用户添加的自定义属性，custom-key 仅是举例，可随意替换',
        },
        'where': {
            'deviceToken': device_token,
        },
    }
    _post_apns_payload(payload)


def _post_apns_payload(payload):
    headers = {
        LeanCloudConfig.APP_ID_HEADER: LeanCloudConfig.APP_ID,
        LeanCloudConfig.APP_KEY_HEADER: LeanCloudConfig.APP_KEY,
        'Content-Type': 'application/json',
    }
    requests.post(LeanCloudConfig.PUSH_URL, data=json.dumps(payload), headers=headers)


def verify_weixin_openid(access_token, openid):
    response = requests.get(WeixinConfig.AUTH_URL, {
        WeixinConfig.ACCESS_TOKEN_KEY: access_token,
        WeixinConfig.OPENID_KEY: openid,
    })
    return response.json().get(WeixinConfig.ERRCODE_KEY) == 0


def verify_weibo_openid(access_token, openid):
    response = requests.get(WeiboConfig.AUTH_URL, {
        WeiboConfig.ACCESS_TOKEN_KEY: access_token,
        WeiboConfig.OPENID_KEY: openid,
    })
    errcode = response.json().get(WeiboConfig.ERRCODE_KEY)
    return errcode is None or errcode == 0


def verify_qq_openid(access_token, openid):
    response = requests.get(QQConfig.AUTH_URL, {
        QQConfig.ACCESS_TOKEN_KEY: access_token,
        QQConfig.APPID_KEY: QQConfig.APPID,
        QQConfig.OPENID_KEY: openid,
        QQConfig.FORMAT_KEY: QQConfig.JSON_FORMAT,
    })
    return response.json().get(QQConfig.ERRCODE_KEY) == 0
