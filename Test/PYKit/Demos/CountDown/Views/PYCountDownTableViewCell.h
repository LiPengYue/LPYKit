//
//  PYCountDownTableViewCell.h
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PYCountDownModel;
@class CountDownHandler;
#import "CountDownHandler.h"


@interface PYCountDownTableViewCell : UITableViewCell<CountDownHandlerViewDelegate>
@property (nonatomic,strong) PYCountDownModel *model;
@property (nonatomic,strong) NSNumber *countDownNumber;
@property (nonatomic,assign) CGFloat currentCountDown;
//@property (nonatomic,weak) CountDownHandler *countDownHandler;

@end
