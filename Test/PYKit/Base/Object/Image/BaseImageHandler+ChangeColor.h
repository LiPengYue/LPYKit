//
//  UIImage+ChangeColor.h
//  Expecta
//
//  Created by 李鹏跃 on 2018/10/11.
//

#import <UIKit/UIKit.h>
#import "BaseImageHandler.h"
typedef enum : NSUInteger {
    /// 反色
    UIImageChangeColorSyleEnum_AntiColor,
    /// 灰色
    UIImageChangeColorSyleEnum_Gray,
    /// 复古
    UIImageChangeColorSyleEnum_Retro
    
} UIImageChangeColorSyleEnum;

/// 图片处理 效果
typedef UIImageChangeColorSyleEnum UIImageChangeColorSyleEnum;
@interface BaseImageHandler (ChangeColor)

/**
 根据image创建新的image并调整newImage亮度、饱和度、对比度
 
 @param image image
 @param brightness 亮度 [-1,1]
 @param saturation 饱和度 [0,2]
 @param contrast 对比度 [0,4]
 @return new image
 */
+ (UIImage *) imageByBSC: (UIImage *)image
           andBrightness: (CGFloat)brightness
           andSaturation: (CGFloat)saturation
             andContrast: (CGFloat)contrast;


/**
 根据image创建新的image并调整newImagergba
 @param image image
 @param isWhiteConversionClear 白色是否转化为透明
 @return new image
 */
+ (UIImage *) imageByRGBA:(UIImage *) image
   isWhiteConversionClear: (BOOL)isWhiteConversionClear
             RGBACallBock:(void(^)(UInt8 *red,
                                   UInt8 *blue,
                                   UInt8 *green,
                                   UInt8 *alpha))block;


/**
 根据image创建新的image并调整newImage 透明度
 
 @param image image
 @param alpha 透明度
 @return new image
 */
+ (UIImage *) imageByApplyingAlpha: (CGFloat)alpha
                             image:(UIImage*)image;


/**
 合并两个image
 @return newImage
 */
+ (UIImage *) imageByMerge:(UIImage *)image1
                   toImage:(UIImage *)image2;

/**
 改变image的 size
 
 @param img image
 @param size size
 @return newImage
 */
+ (UIImage *)imageByScaleToSize:(UIImage *)img
                           size:(CGSize)size;

/**
 修改图片风格
 @param image image
 @param type UIImageChangeColorSyleEnum 风格
 @return new image
 */
+ (UIImage *) imageByStyle:(UIImage *)image
                      type:(UIImageChangeColorSyleEnum)type;

/**
 image 填充色
 
 @param color 颜色
 @return new image
 */
+ (UIImage *) imageByFullColor: (UIImage *)image color:(UIColor *)color;

@end
