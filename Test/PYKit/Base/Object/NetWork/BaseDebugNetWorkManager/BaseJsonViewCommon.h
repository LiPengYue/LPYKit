//
//  BaseJsonViewCommon.h
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewHeaders.h"
#import "BaseObjectHeaders.h"
#import "BaseSize.h"


NS_ASSUME_NONNULL_BEGIN
#define searchResultCellKeyColor BaseColorHandler.cHex(0xbb1542)
#define numberColor BaseColorHandler.cHex(0x01AAED)
#define stringColor BaseColorHandler.cHex(0x009900)
#define errorColor BaseColorHandler.cHex(0xeb5f5d)
#define leftTitleColor BaseColorHandler.cHex(0x66512C)
#define normalColor BaseColorHandler.cHex(0x333333)
#define cellBackgroundSearchReslutColor BaseColorHandler.cHex(0xd3f6f3)
#define cellBackgroundCurrentSearchColor BaseColorHandler.cHex(0x93b5b3)

#define cellLevelLabelColor BaseColorHandler.cHex(0xCCCC99)
#define messageColor BaseColorHandler.cHex(0xdff0ea)

#define editActionBackgroundColor [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1]
#define copyActionBackgroundColor [UIColor colorWithRed:0.6 green:0.7 blue:0.6 alpha:1]
#define copyStrActionBackgroundColor [UIColor colorWithRed:0.4 green:0.5 blue:0.4 alpha:1]
#define deleteActionBackgroundColor [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1]

#define tableViewCellLeftFont [UIFont fontWithName:@"PingFangSC-Medium" size:12]
#define tableViewCellColonLabelFont BaseFont.fontSCM(10)
#define tableViewCellTagFont BaseFont.fontSCL(10)
#define tableViewCellRightFont [UIFont systemFontOfSize:12]
#define tableViewCellLevelFont BaseFont.fontSCL(12)

#define tableViewCellLevelSpacing 10
#define tableViewCellLeftSpacing 10
#define tableViewCellRightSpacing 10
#define tableViewCellTopMinSpacing 5
#define tableViewCellBottomMinSpacing 5

#define tableViewCellLeftLineTopBottomMinSpacing 1

/// 在第几层开始跳转到新的控制器进行显示
#define tableViewCellMaxLevel 2

#define kScreenW UIScreen.mainScreen.bounds.size.width

#define jsonHandlerScrrenW

@interface BaseJsonViewCommon : NSObject

@end

NS_ASSUME_NONNULL_END
