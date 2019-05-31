//
//  BaseTheme.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseColorHandler.h"

typedef enum : NSUInteger {
    BaseThemeColor_default,
    BaseThemeColor_dark
} EBaseThemeColor;

typedef enum : NSUInteger {
    EBaseThemeFont_default,
    EBaseThemeFont_big,
} EBaseThemeFont;


typedef id _Nullable (^BaseThemeManagerBlock)(void);
typedef CGFloat(^BaseThemeManagerFontBlock)(void);

NS_ASSUME_NONNULL_BEGIN
@interface BaseThemeManager : NSObject

/// EBaseTheme
@property (class,readonly,nonatomic,assign) EBaseThemeColor colorTheme;
@property (class,readonly,nonatomic,assign) EBaseThemeFont fontTheme;

@property (nonatomic,assign) EBaseThemeColor instanceColorTheme;
@property (nonatomic,assign) EBaseThemeFont instanceFontTheme;


+ (instancetype) manager;

+ (id) colorThemeDefault: (BaseThemeManagerBlock)def
            andDark: (BaseThemeManagerBlock) dark;


+ (CGFloat) fontThemeGetHeight;
@end

NS_ASSUME_NONNULL_END
