# -*- coding: utf-8 -*-
# Generated by Django 1.9.5 on 2016-06-26 13:59
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='UserMobile',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('mobile', models.CharField(blank=True, max_length=50, null=True)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='user_mobile', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.RemoveField(
            model_name='medal',
            name='map',
        ),
        migrations.AddField(
            model_name='map',
            name='medal',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='map', to='api.Medal'),
        ),
        migrations.AddField(
            model_name='map',
            name='published',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='story',
            name='owners',
            field=models.ManyToManyField(related_name='stories', through='api.UserStory', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='story',
            name='published',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='task',
            name='medal',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='task', to='api.Medal'),
        ),
        migrations.AddField(
            model_name='userstory',
            name='like',
            field=models.BooleanField(default=False),
        ),
        migrations.AlterField(
            model_name='anchor',
            name='type',
            field=models.CharField(choices=[('task', '\u9009\u62e9\u9898'), ('story', '\u6545\u4e8b')], default='task', max_length=10),
        ),
        migrations.AlterField(
            model_name='levelcoupon',
            name='remain',
            field=models.IntegerField(default=0),
        ),
        migrations.AlterField(
            model_name='userdevicetoken',
            name='installation_id',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
        migrations.AlterUniqueTogether(
            name='anchor',
            unique_together=set([('type', 'ref_id')]),
        ),
    ]
