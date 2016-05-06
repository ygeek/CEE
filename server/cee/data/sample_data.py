# -*- coding: utf-8 -*-

# from __future__ import unicode_literals
from __future__ import absolute_import

import datetime
import geohash
from api.models import *


user = User(username='15910603382')
user.set_password('87655161Zm')
user.save()

city = City.objects.get(key='1000010000')


story = Story(name='测试故事',
              desc='这是一个测试故事，一个神奇的故事，凑一凑字数。',
              time=120,
              good=232,
              difficulty=4,
              distance=5.1,
              tags=['美食', '运动', '小游戏', '人物', '室外'],
              city=city,
              coin=100,
              image_keys=['sample_big1_jpg', 'sample_big2_jpg'],
              tour_image_key='sample_small_png',
              hud_image_key='sample_big1_jpg')
story.save()


level_dialog = Level(name='测试对话关卡',
                     content={'type': 'dialog',
                              'img': 'sample_big1_jpg',
                              'sayer': '说话人的名字',
                              'text': '这是一段对白啊对白\n还带换行的!', })
level_dialog.save()


level_video = Level(name='测试视频关卡',
                    content={'type': 'video',
                             'video_key': 'sample_video_mp4'})
level_video.save()


level_num_puzzle = Level(name='测试数字谜题关卡',
                         content={'type': 'number',
                                  'img': 'sample_big1_jpg',
                                  'text': '这是谜题的说明文字啊',
                                  'answer': '1234'})
level_num_puzzle.save()


level_text_puzzle = Level(name='测试文字谜题关卡',
                          content={'type': 'text',
                                   'img': 'sample_big2_jpg',
                                   'text': '这是谜题的说明文字啊',
                                   'answer': 'answer123'})
level_text_puzzle.save()


level_empty = Level(name='测试空白关卡',
                    content={'type': 'empty',
                             'img': 'sample_big1_jpg',
                             'event': 'event1'})
level_empty.save()


level_h5 = Level(name='测试H5关卡',
                 content={'type': 'h5',
                          'url': 'http://www.baidu.com'})
level_h5.save()


story_level_1 = StoryLevel(story=story,
                           level=level_dialog,
                           order=0)
story_level_1.save()

story_level_2 = StoryLevel(story=story,
                           level=level_video,
                           order=1)
story_level_2.save()

story_level_3 = StoryLevel(story=story,
                           level=level_num_puzzle,
                           order=2)
story_level_3.save()


story_level_4 = StoryLevel(story=story,
                           level=level_text_puzzle,
                           order=3)
story_level_4.save()


story_level_5 = StoryLevel(story=story,
                           level=level_empty,
                           order=4)
story_level_5.save()


story_level_6 = StoryLevel(story=story,
                           level=level_h5,
                           order=5)
story_level_6.save()


item_1 = Item(name='导航到天安门测试道具',
              activate_at=1,
              content={'type': 'navigation',
                       'icon': 'sample_small_png',
                       'text': '这是一段说明文字啊说明文字',
                       'event': 'event1',
                       'latitude': 39.90,
                       'longitude': 116.38})
item_1.save()


item_2 = Item(name='测试纸条道具',
              activate_at=2,
              content={'type': 'note',
                       'icon': 'sample_small_png',
                       'text': '这是纸条上的内容:哈哈哈'})
item_2.save()


item_3 = Item(name='测试锁箱道具',
              activate_at=3,
              content={'type': 'lock',
                       'icon': 'sample_small_png',
                       'text': '这又是一段说明文字啊说明文字',
                       'event': 'event2'})
item_3.save()


story_item_1 = StoryItem(story=story, item=item_1)
story_item_1.save()
story_item_2 = StoryItem(story=story, item=item_2)
story_item_2.save()
story_item_3 = StoryItem(story=story, item=item_3)
story_item_3.save()


task = Task(name='测试任务',
            desc='这是一组测试用选择题',
            location='北京天安门',
            coin=100,
            award_image_key='sample_big1_jpg')
task.save()

choice1 = Choice(task=task,
                 order=0,
                 name='第一道题',
                 desc='这是第一道选择题的描述描述',
                 image_key='sample_big1_jpg',
                 answer=0,
                 answer_message='答对以后就会告诉你这样的消息',
                 answer_next='点这里跳到下一题',
                 answer_image_key='sample_big1_jpg')
choice1.save()

option10 = Option(choice=choice1,
                  order=0,
                  desc='这是选项一的描述啊!')
option10.save()

option11 = Option(choice=choice1,
                  order=1,
                  desc='这是另外一个选项描述!')
option11.save()

option12 = Option(choice=choice1,
                  order=2,
                  desc='这是第三个选项!')
option12.save()

option13 = Option(choice=choice1,
                  order=3,
                  desc='这是最后一个选项')
option13.save()

choice2 = Choice(task=task,
                 order=1,
                 name='第二道题',
                 desc='这是第二道选择题描述',
                 image_key='sample_big2_jpg',
                 answer=1,
                 answer_message='答对以后就会告诉你这样的消息',
                 answer_next='点这里跳到下一题',
                 answer_image_key='sample_big2_jpg')
choice2.save()

option20 = Option(choice=choice2,
                  order=0,
                  desc='这是选项一的描述啊!')
option20.save()

option21 = Option(choice=choice2,
                  order=1,
                  desc='这是另外一个选项描述!')
option21.save()

option22 = Option(choice=choice2,
                  order=2,
                  desc='这是第三个选项!')
option22.save()

option23 = Option(choice=choice2,
                  order=3,
                  desc='这是最后一个选项')
option23.save()

coupon = Coupon(name='万达优惠券',
                location='万达XX餐厅',
                image_key='sample_big1_jpg',
                desc={'现金折扣 八五折': '持本券即可获得付款八五折\n优惠同时可与其他折扣同时使用',
                      '附赠小食': '获得小食一碟\n具体到店酌情而定'},
                gmt_start=datetime.date(year=2016, month=5, day=1),
                gmt_end=datetime.date(year=2017, month=5, day=1),
                code='1234',
                is_deleted=False)
coupon.save()

level_coupon_1 = LevelCoupon(story=story,
                             level=level_text_puzzle,
                             coupon=coupon,
                             amount=100,
                             remain=100)
level_coupon_1.save()


user_coupon_1 = UserCoupon(user=user,
                           coupon=coupon,
                           story=story,
                           level=level_text_puzzle,
                           consumed=False)
user_coupon_1.save()

user_coupon_2 = UserCoupon(user=user,
                           coupon=coupon,
                           story=story,
                           level=level_text_puzzle,
                           consumed=False)
user_coupon_2.save()

user_coupon_3 = UserCoupon(user=user,
                           coupon=coupon,
                           story=story,
                           level=level_text_puzzle,
                           consumed=False)
user_coupon_3.save()


map1 = Map(name='北京天安门',
           desc='这里是北京天安门!',
           longitude=116.38,
           latitude=39.9,
           geohash=geohash.encode(longitude=116.38, latitude=39.9),
           image_key='sample_map',
           icon_key='sample_small_png',
           summary_image_key='sample_big2_jpg',
           city=city)
map1.save()

map2 = Map(name='北京大学',
           desc='这里是北京大学!',
           longitude=116.32,
           latitude=39.99,
           geohash=geohash.encode(longitude=116.32, latitude=29.99),
           image_key='sample_map',
           icon_key='sample_small_png',
           summary_image_key='sample_big1_jpg',
           city=city)
map2.save()

anchor1 = Anchor(map=map1,
                 name='天安门1',
                 dx=100,
                 dy=200,
                 type=Anchor.Type.Story,
                 ref_id=story.id)
anchor1.save()

anchor2 = Anchor(map=map1,
                 name='北京大学1',
                 dx=200,
                 dy=100,
                 type=Anchor.Type.Story,
                 ref_id=story.id)
anchor2.save()

anchor3 = Anchor(map=map2,
                 name='北京大学2',
                 dx=200,
                 dy=100,
                 type=Anchor.Type.Story,
                 ref_id=story.id)
anchor3.save()


anchor4 = Anchor(map=map1,
                 name='便利店',
                 dx=300,
                 dy=150,
                 type=Anchor.Type.Task,
                 ref_id=task.id)
anchor4.save()


medal1 = Medal(map=map1,
               name='测试勋章1',
               desc='这是第一个测试勋章',
               icon_key='sample_small_png')
medal1.save()

user_medal_1 = UserMedal(user=user, medal=medal1)
user_medal_1.save()


medal2 = Medal(map=map2,
               name='测试勋章2',
               desc='这是第2个测试勋章',
               icon_key='sample_small_png')
medal2.save()

user_medal_2 = UserMedal(user=user, medal=medal2)
user_medal_2.save()
