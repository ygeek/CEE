# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-07-01 15:25
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0003_auto_20160701_2252'),
    ]

    operations = [
        migrations.CreateModel(
            name='LoginReward',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('desc', models.TextField()),
                ('amount', models.IntegerField()),
                ('gmt_start', models.DateField()),
                ('gmt_stop', models.DateField()),
            ],
        ),
        migrations.CreateModel(
            name='UserLoginReward',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('gmt_created', models.DateTimeField(auto_now_add=True)),
                ('reward', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_login_rewards', to='api.LoginReward')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_login_rewards', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
