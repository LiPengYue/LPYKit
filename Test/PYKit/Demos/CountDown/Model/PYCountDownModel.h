//
//  PYCountDownModel.h
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CountDownHandler;
@class PYCountDownTableViewCell;
#import "CountDownHandler.h"
@interface PYCountDownModel : NSObject<CountDownHandlerDataSource>
/// 倒计时总时间
@property (nonatomic,assign) NSInteger countDownNum;
///是否显示倒计时
@property (nonatomic,assign) NSInteger isShowCountDown;
///当前的倒计时剩余时间
@property (nonatomic,assign) CGFloat currentCountDown;

@end
