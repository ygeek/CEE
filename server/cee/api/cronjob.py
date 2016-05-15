# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import unicode_literals

import datetime
import time
import logging

from django_cron import CronJobBase, Schedule
import api.services
from api.models.coupon import *
from api.models.message import *


class CouponMessageJob(CronJobBase):
    RUN_EVERY_MINS = 60 * 24  # every day

    schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
    code = 'api.coupon_message_job'

    def do(self):
        today = datetime.date.today()
        expired_date = today + datetime.timedelta(days=5)
        coupons = Coupon.objects.filter(gmt_end__gte=today,
                                        gmt_end__lte=expired_date)
        for coupon in coupons:
            for user_coupon in coupon.user_coupons:
                text = '您有条优惠券即将过期--{0}'.format(coupon.name)
                message = Message(user=user_coupon.user,
                                  type=Message.Type.Coupon,
                                  timestamp=int(time.time()),
                                  text=text,
                                  unread=True,
                                  coupon_id=coupon.id)
                message.save()
                device_token = user_coupon.user.device_token.device_token
                api.services.push_apns_notification(text, device_token)


class TestCronJob(CronJobBase):
    RUN_EVERY_MINS = 60 * 24  # every day

    schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
    code = 'api.test_job'

    def do(self):
        logging.getLogger('debug').log(logging.DEBUG, 'cron job run!')
