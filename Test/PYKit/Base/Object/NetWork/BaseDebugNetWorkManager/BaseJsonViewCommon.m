//
//  BaseJsonViewCommon.m
//  PYkit
//
//  Created by 衣二三 on 2019/7/2.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseJsonViewCommon.h"

@implementation BaseJsonViewCommon
+ (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    CGSize size = CGSizeMake(width, 999);
    
    NSDictionary *dic = @{NSFontAttributeName:font};
    
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}
@end
