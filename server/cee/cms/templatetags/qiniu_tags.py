import qiniu
from django import template

from api.config import QiniuConfig

register = template.Library()


@register.filter
def download_url(value):
    q = qiniu.Auth(QiniuConfig.ACCESS_KEY, QiniuConfig.SECRET_KEY)
    key = value
    domain = QiniuConfig.BUCKET_DOMAIN
    base_url = 'http://{0}/{1}'.format(domain, key)
    private_url = q.private_download_url(base_url)
    return private_url
