//
//  BaseImageAttribuilteStr.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseImageHandler : NSObject


/**
 image data， 最大边长为maxBorder
 */
+ (BaseImageHandler *(^)(NSData *imageData, CGFloat maxBorder)) createWithData;

/**
 @str image name
 */
+ (BaseImageHandler *(^)(NSString *imageName)) createWithImageName;
+ (BaseImageHandler *(^)(UIImage *image)) createWithImage;
+ (BaseImageHandler *(^)(id data))handle;
/// image
@property (nonatomic,strong) UIImage * image;

#pragma mark - str
/// image
- (NSTextAttachment *) getImageAttchment;

/**
 * 设置image 字符穿的 bounds
 */
- (BaseImageHandler *(^)(CGRect bounds)) setUpBounds;


/**
 * 在imagestr 左（或上）边添加一个相应位置、大小的 “ ”,从而添加间距
 */
- (BaseImageHandler *(^)(CGFloat offsetX)) setUpOffsetLeftX;

/**
 * 在imagestr 左（或上）边添加一个相应位置、大小的 “ ”,从而添加间距
 */
@property (nonatomic,assign) CGFloat offsetLeftX;

/**
 * 在imagestr 右边（或下）边添加一个相应位置、大小的 “ ”,从而添加间距
 */
- (BaseImageHandler *(^)(CGFloat offsetX)) setUpOffsetRightX;

/**
 * 在imagestr 右（或下）边添加一个相应位置、大小的 “ ”,从而添加间距
 */
@property (nonatomic,assign) CGFloat offsetRightX;

/**
 * 改变bounds y，注意，这个属性可能会影响最后的attributedString高度计算
 */
- (BaseImageHandler *(^)(CGFloat offsetY)) setUpOffsetY;
@property (nonatomic,assign) CGFloat offsetY;


/**
 *image的大小
 */
- (BaseImageHandler *(^)(CGSize size)) setUpImageSize;

/**
 获取垂直对齐Str offsetY
 @ fontH 字体高度
 @return offsetY
 */
- (CGFloat) getImageStrYWithFont: (UIFont *)font;

- (BaseImageHandler *(^)(UIFont *))setUpYWithFont;

- (BaseImageHandler *(^)(UIColor *color)) setUpImageColor;

/**
 生成富文本 的image str
 */
- (NSAttributedString *) getImageStr;



- (CGFloat) getMaxw;
- (CGFloat) getMaxH;
@end

NS_ASSUME_NONNULL_END
