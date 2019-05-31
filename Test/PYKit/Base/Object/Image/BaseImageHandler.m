//
//  BaseImageAttribuilteStr.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseImageHandler.h"
#import "BaseImageHandler+ChangeColor.h"
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif
UIImage * createThumbnailImageFromData(NSData *data, CGFloat size);
@interface BaseImageHandler()
@property (nonatomic,strong) NSTextAttachment *imageAttachment;
@end


@implementation BaseImageHandler

+ (BaseImageHandler *(^)(id data))handle {
    return ^(id data) {
        UIImage *image;
        if ([data isKindOfClass:NSString.class]) {
            image = [UIImage imageNamed:data];
        }
        else if ([data isKindOfClass:UIImage.class]) {
            image = data;
        }
        else {
            DLog(@"🌶 创建 image失败 : %@",data);
            image = [UIImage new];
        }
        return BaseImageHandler.createWithImage(image);
    };
}

+ (BaseImageHandler * _Nonnull (^)(NSString * _Nonnull))createWithImageName {
    return ^(NSString *name) {
        BaseImageHandler *img = [BaseImageHandler new];
        img.image = [UIImage imageNamed:name];
        
        if (!img.image) {
            img.image = [UIImage new];
            DLog(@"\n🌶：【BaseImage】 createWithImageName没有imageName对应的image,生成了【UIImage new】");
        }
        return img;
    };
}

+ (BaseImageHandler * _Nonnull (^)(UIImage * _Nonnull))createWithImage {
    return ^(UIImage *image) {
        BaseImageHandler *img = [BaseImageHandler new];
        img.image = image;
        
        if (!img.image) {
            img.image = [UIImage new];
            DLog(@"\n🌶：【BaseImage】 createWithImage image为nil,生成了【UIImage new】");
        }
        return img;
    };
}

+ (BaseImageHandler *(^)(NSData *imageData,CGFloat maxBorder)) createWithData {
    return ^(NSData *data, CGFloat maxBorder) {
        return BaseImageHandler.handle(createThumbnailImageFromData(data, maxBorder));
    };
}



- (void) setImageNewPropertyIfIsNull {
    if (!_image) {
        _image = [UIImage new];
        DLog(@"\n🌶：【BaseImage】 createWithImageName没有imageName对应的image,生成了【UIImage new】");
    }
}


#pragma mark - str

/**
 * 设置image 字符穿的 bounds
 */
- (BaseImageHandler *(^)(CGRect bounds)) setUpBounds {
    return ^(CGRect bounds) {
        bounds.origin.y += self.offsetY;
        self.imageAttachment.bounds = bounds;
        return self;
    };
}

- (BaseImageHandler *(^)(UIColor *color)) setUpImageColor {
    return ^(UIColor * color) {
        self.image = [BaseImageHandler imageByFullColor:self.image color:color];
        return self;
    };
}

- (BaseImageHandler *(^)(CGFloat offsetX)) setUpOffsetRightX {
    return ^(CGFloat x) {
        self.offsetRightX = x;
        return self;
    };
}
- (BaseImageHandler *(^)(CGFloat offsetX)) setUpOffsetLeftX {
    return ^(CGFloat x) {
        self.offsetLeftX = x;
        return self;
    };
}



/**
 * 改变bounds y，注意，这个属性可能会影响最后的attributedString高度计算
 */
- (BaseImageHandler *(^)(CGFloat offsetY)) setUpOffsetY {
    return ^(CGFloat y) {
        self.offsetY = y;
        CGRect bounds = [self getImageBounds];
        bounds.origin.y += y;
        self.imageAttachment.bounds = bounds;
        return self;
    };
}


/**
 *image的大小
 */
- (BaseImageHandler *(^)(CGSize size)) setUpImageSize {
    return ^(CGSize size) {
        CGRect rect = [self getImageBounds];
        rect.size = size;
        self.imageAttachment.bounds = rect;
        return self;
    };
}

- (CGRect) getImageBounds {
    CGRect bounds = self.imageAttachment.bounds;
    if (CGRectEqualToRect(bounds, CGRectZero)) {
        bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
    self.imageAttachment.bounds = bounds;
    return bounds;
}

/**
 获取垂直对齐Str offsetY
 @param fontH 字体高度
 @return offsetY
 */
- (CGFloat) getImageStrYWithFont: (UIFont *) font {
    CGFloat fontH = font.capHeight;
    CGRect bounds = [self getImageBounds];
    CGFloat h = bounds.size.height;
    return (fontH - h)/2;
}
- (BaseImageHandler *(^)(UIFont *))setUpYWithFont {
    return ^(UIFont *font) {
        CGFloat y = [self getImageStrYWithFont:font];
        self.setUpOffsetY(y);
        return self;
    };
}
/**
 生成富文本 的image str
 */
- (NSAttributedString *) getImageStr {
    NSAttributedString *imageStr = [NSMutableAttributedString attributedStringWithAttachment:self.imageAttachment];
    if(self.offsetLeftX != 0) {
        NSMutableAttributedString *offsetXStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [offsetXStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ABS(self.offsetLeftX)] range:NSMakeRange(0, 1)];
        [offsetXStr appendAttributedString:imageStr];
        imageStr = offsetXStr;
    }
    
    if (self.offsetRightX != 0){
        NSMutableAttributedString *offsetXStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [offsetXStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ABS(self.offsetRightX)] range:NSMakeRange(0, 1)];
        [offsetXStr insertAttributedString:imageStr atIndex:0];
        imageStr = offsetXStr;
    }
    return imageStr;
}

- (NSTextAttachment *) getImageAttchment {
    return self.imageAttachment;
}

#pragma mark - set && get
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageAttachment = [[NSTextAttachment alloc]init];
    self.imageAttachment.image = image;
}

- (NSTextAttachment *) imageAttachment {
    if (!_imageAttachment) {
        _imageAttachment = [NSTextAttachment new];
    }
    return _imageAttachment;
}

- (CGFloat) getMaxw {
    return self.image.size.width + ABS(self.offsetRightX) + ABS(self.offsetLeftX);
}
- (CGFloat) getMaxH {
    return CGRectGetMaxY(self.imageAttachment.bounds);
}
@end




UIImage * createThumbnailImageFromData(NSData *data, CGFloat size) {
    
    if(data == nil) {
        return nil;
    }
    
    CFStringRef thumbnailKeysRef[3];
    CFStringRef thumbnailValuesRef[3];
    CFDictionaryRef thumbnailOptionsRef;
    CGImageSourceRef imageSourceRef;
    CFNumberRef thumbnailSizeRef;
    CGImageRef imageRef;
    
    thumbnailSizeRef = CFNumberCreate(NULL, kCFNumberDoubleType, &size);
    
    thumbnailKeysRef[0] = kCGImageSourceCreateThumbnailWithTransform;
    thumbnailValuesRef[0] = (CFTypeRef)kCFBooleanTrue;
    
    thumbnailKeysRef[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    thumbnailValuesRef[1] = (CFTypeRef)kCFBooleanTrue;
    
    thumbnailKeysRef[2] = kCGImageSourceThumbnailMaxPixelSize;
    thumbnailValuesRef[2] = (CFTypeRef)thumbnailSizeRef;
    
    thumbnailOptionsRef = CFDictionaryCreate(NULL,
                                          (const void **)thumbnailKeysRef,
                                          (const void **)thumbnailValuesRef,
                                          3,
                                          &kCFTypeDictionaryKeyCallBacks,
                                          &kCFTypeDictionaryValueCallBacks
                                          );
    
    imageSourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    
    imageRef = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, thumbnailOptionsRef);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    if(thumbnailOptionsRef) {CFRelease(thumbnailOptionsRef);}
    if(imageSourceRef)      {CFRelease(imageSourceRef);}
    if(thumbnailSizeRef)    {CFRelease(thumbnailSizeRef);}
    if(imageRef)            {CFRelease(imageRef);}
    
    return image;
}
