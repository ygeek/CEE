# -*- coding: utf-8 -*-
# Generated by Django 1.10 on 2016-04-13 11:22
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_anchor_coupon_item_level_story_useranchor_useritem_usermap'),
    ]

    operations = [
        migrations.AlterField(
            model_name='coupon',
            name='coupon_id',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='item',
            name='item_id',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='level',
            name='level_id',
            field=models.IntegerField(),
        ),
        migrations.AlterField(
            model_name='story',
            name='story_id',
            field=models.IntegerField(),
        ),
    ]