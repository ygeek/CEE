# -*- coding: utf-8 -*-

from __future__ import unicode_literals


class LeanCloudConfig(object):
    APP_ID = 'zbamEfqUbNTXNwLKw8LiTPK0-gzGzoHsz'
    APP_KEY = 'nWuVXVcpDSr4Eu3DHJqqSDyY'
    PUSH_URL = 'https://leancloud.cn/1.1/push'
    APP_ID_HEADER = 'X-LC-Id'
    APP_KEY_HEADER = 'X-LC-Key'


class QiniuConfig(object):
    ACCESS_KEY = 'HZy9WBbmLw0Y3QDT3TjyiyyrE4DpAdLKww15Wlmt'
    SECRET_KEY = '19hjy43oWfSXdtVMXfdWA029wtKOpb7tFJ1bgV-i'
    BUCKET_NAME = 'ceebucket'
    BUCKET_DOMAIN = '7xt08d.com1.z0.glb.clouddn.com'
    BUCKET_DOMAIN_1 = '7xt08d.com1.z0.glb.clouddn.com'
    BUCKET_DOMAIN_2 = '7xt08d.com2.z0.glb.clouddn.com'
    BUCKET_DOMAIN_3 = '7xt08d.com2.z0.glb.qiniucdn.com'


class WeixinConfig(object):
    """
    Weixin API: https://open.weixin.qq.com/cgi-bin/showdocument
                ?action=dir_list&t=resource/res_list&verify=1&id=open1419316518&token=&lang=zh_CN
    """
    AUTH_URL = 'https://api.weixin.qq.com/sns/auth'
    ACCESS_TOKEN_KEY = 'access_token'
    OPENID_KEY = 'openid'
    ERRCODE_KEY = 'errcode'


class QQConfig(object):
    """
    QQ API: http://wiki.open.qq.com/wiki/website/get_user_info

    """
    APPID = '12345'  # TODO (zhangmeng): 等正式APP ID
    AUTH_URL = 'https://graph.qq.com/user/get_user_info'
    ACCESS_TOKEN_KEY = 'access_token'
    APPID_KEY = 'oauth_consumer_key'
    OPENID_KEY = 'openid'
    FORMAT_KEY = 'format'
    JSON_FORMAT = 'json'
    ERRCODE_KEY = 'ret'


class WeiboConfig(object):
    """
    Weibo API: http://open.weibo.com/wiki/2/users/show
    """
    AUTH_URL = 'https://api.weibo.com/2/users/show.json'
    ACCESS_TOKEN_KEY = 'access_token'
    OPENID_KEY = 'uid'
    ERRCODE_KEY = 'error_code'
