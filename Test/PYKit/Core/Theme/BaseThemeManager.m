//
//  BaseTheme.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseThemeManager.h"
@interface BaseThemeManager()
@end

@implementation BaseThemeManager

+ (instancetype)manager {
    static BaseThemeManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [BaseThemeManager new];
    });
    return _manager;
}


//MARK: get && set
+ (EBaseThemeFont) fontTheme {
    return [BaseThemeManager manager].instanceFontTheme;
}

+ (EBaseThemeColor) colorTheme {
    return [BaseThemeManager manager].instanceColorTheme;
}



+ (id) colorThemeDefault: (BaseThemeManagerBlock)def
            andDark: (BaseThemeManagerBlock) dark {
    
    switch (BaseThemeManager.colorTheme) {
            
        case BaseThemeColor_default:
            if (def) return def(); break;
            
        case BaseThemeColor_dark:
            if (dark) return dark(); break;
            
        default: return [NSNull null];
    }
    return [NSNull null];
}


+ (CGFloat) fontThemeGetHeight {
    switch (BaseThemeManager.fontTheme) {
            
        case EBaseThemeFont_default:
            return 1;
            
        case EBaseThemeFont_big:
            return 1.1;
            
        default: return 1;
    }
}
@end
