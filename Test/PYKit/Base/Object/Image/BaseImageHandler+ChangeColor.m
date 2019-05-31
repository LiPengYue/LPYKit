//
//  UIImage+ChangeColor.m
//  Expecta
//
//  Created by 李鹏跃 on 2018/10/11.
//

#import "BaseImageHandler+ChangeColor.h"

@implementation BaseImageHandler (ChangeColor)

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}


/**
 根据image创建新的image并调整其亮度、饱和度、对比度
 
 @param image image
 @param brightness 亮度
 @param saturation 饱和度
 @param contrast 对比度
 @return new image
 */
+ (UIImage*) imageByBSC: (UIImage *)image
          andBrightness: (CGFloat)brightness
          andSaturation: (CGFloat)saturation
            andContrast: (CGFloat)contrast;
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:superImage forKey:kCIInputImageKey];
    
    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(brightness) forKey:@"inputBrightness"];
    
    // 修改饱和度  0---2
    [lighten setValue:@(saturation) forKey:@"inputSaturation"];
    
    // 修改对比度  0---4
    [lighten setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    
    // 得到修改后的图片
    image = [UIImage imageWithCGImage:cgImage];
    
    // 释放对象
    CGImageRelease(cgImage);
    return image;
}

+ (UIImage *) imageByRGBA:(UIImage*) image
   isWhiteConversionClear: (BOOL)isWhiteConversionClear
             RGBACallBock:(void(^)(UInt8 *red,
                                   UInt8 *blue,
                                   UInt8 *green,
                                   UInt8 *alpha))block{
    
    
    CGImageRef  imageRef;
    imageRef = image.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue,alpha;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            if (block) {
                block(&red,&green,&blue,&alpha);
            }
            
            *(tmp + 0) = red;
            *(tmp + 1) = green;
            *(tmp + 2) = blue;
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}



//设置图片透明度
+ (UIImage *) imageByApplyingAlpha: (CGFloat)alpha  image:(UIImage*)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



//合并2张图片

+ (UIImage *)imageByMerge:(UIImage *)image1 toImage:(UIImage *)image2 {
    
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}





//将UIImage缩放到指定大小尺寸：

+ (UIImage *)imageByScaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
    
}


// 裁切图片
+ (UIImage *)setUpFitWithSize:(CGSize)size image: (UIImage *)image{
    if (nil == image)
        return nil;
    
    if (image.size.width < size.width && image.size.height < size.height)
        return image;
    
    UIGraphicsBeginImageContext(size);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    [image drawInRect:rect];
    
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newing;
}


+ (UIImage *) imageByStyle:(UIImage *)image type:(UIImageChangeColorSyleEnum)type {
    return [self grayscale:image type:type];
    //    switch (type) {
    //        case UIImageChangeColorSyleEnum_AntiColor:
    //            return [self imageByRGBA:image isWhiteConversionClear:false RGBACallBock:^(UInt8 *red, UInt8 *blue, UInt8 *green, UInt8 *alpha) {
    //                *red = 255 - *red;
    //                *blue = 255 - *blue;
    //                *green = 255 - *green;
    //            }];
    //            break;
    //        case UIImageChangeColorSyleEnum_Gray:
    //           return [self imageByRGBA:image isWhiteConversionClear:false RGBACallBock:^(UInt8 *red, UInt8 *blue, UInt8 *green, UInt8 *alpha) {
    //
    //               CGFloat brightness = *red * 77;
    //               brightness += *green * 28;
    //               brightness += *blue * 151;
    //               brightness /= 256;
    //
    //                *red = brightness;
    //                *blue = brightness;
    //                *green = brightness;
    //            }];
    //            break;
    //
    //        case UIImageChangeColorSyleEnum_Retro:
    //            return [self imageByRGBA:image isWhiteConversionClear:false RGBACallBock:^(UInt8 *red, UInt8 *blue, UInt8 *green, UInt8 *alpha) {
    //                *blue = *blue * 0.4;
    //                *green = *green * 0.7;
    //            }];
    //            break;
    //        default:
    //            break;
    //    }
}

+ (UIImage*) grayscale:(UIImage*)anImage type:(UIImageChangeColorSyleEnum)type {
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            
            switch (type) {
                case UIImageChangeColorSyleEnum_Gray://モノクロ
                    // 輝度計算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                    
                case UIImageChangeColorSyleEnum_Retro://セピア
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                    
                case UIImageChangeColorSyleEnum_AntiColor://色反転
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                    
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}


+ (UIImage *) imageByFullColor: (UIImage *)image color:(UIColor *)color {
   /**
    * 第一个参数是想要渲染的图片的尺寸;
    * 第二个参数用来指定所生成图片的背景是否为不透明，指定为YES得到的图片背景将会是黑色，反之NO表示是透明的;
    * 第三个参数表示位图的缩放比例，如果设置为 0，表示让图片的缩放因子根据屏幕的分辨率而变化。和 [UIScreen mainScreen].scale相等的。
    *
    * UIGraphicsBeginImageContext(CGSize size)仅有一个参数，传递的是想要渲染位图的尺寸。和 UIGraphicsBeginImageContextWithOptions(CGSize size, NO, 1.0) 是等价的。
    
    * UIGraphicsBeginImageContextWithOptions(CGSize size, YES, 0) 得到的图片失真很少，比较接近原图像，而 UIGraphicsBeginImageContext()这个方法得到的图片质量相对来说比较差。
    */
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
