# -*- coding: utf-8 -*-

from __future__ import unicode_literals

import json
import requests

from .config import LeanCloudConfig


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


def push_apns_notification(message, installation_id, is_prod=True):
    payload = {
        'prod': 'prod' if is_prod else 'dev',
        'data': {
            'alert': message,
            'badge': 'Increment',
            # 'custom-key': '由用户添加的自定义属性，custom-key 仅是举例，可随意替换',
        },
        'where': {
            'installationId': installation_id,
        },
    }
    _post_apns_payload(payload)


def _post_apns_payload(payload):
    headers = {
        'X-LC-Id': LeanCloudConfig.APP_ID,
        'X_LC_Key': LeanCloudConfig.APP_KEY,
        'Content-Type': 'application/json',
    }
    requests.post(LeanCloudConfig.PUSH_URL, data=json.dumps(payload), headers=headers)
