//
//  BaseNavigationBarView.h
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/10/26.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickNavTitle)(UIButton *button);
typedef void(^CliekNavItem)(UIButton *button,NSInteger index);

@interface BaseNavigationBarView : UIView

/**
 刷新UI
 */
- (void) reloadView;

- (void) setUpWeakSelfFunc: (void(^)(BaseNavigationBarView *weak))block;

/** 左边的buttons */
@property (nonatomic,strong,readonly) NSArray <UIButton *>*leftItems;
/** 右边的buttons */
@property (nonatomic,strong,readonly) NSArray <UIButton *>*rightItems;
/**
 title
 替换 这个view 来 自定义 titleLabel
 */
@property (nonatomic,strong) UIButton *titleButton;

#pragma mark - 插入item
- (BaseNavigationBarView *(^)(UIButton *button)) addLeftItem;
- (BaseNavigationBarView *(^)(UIButton *button)) addRightItem;

// MARK: 根据 str 与 image 创建Button 并添加到数组
- (BaseNavigationBarView *(^)(NSString *str,UIImage *image)) addLeftItemWithTitleAndImg;
- (BaseNavigationBarView *(^)(NSString *str,UIImage *image)) addRightItemWithTitleAndImg;
- (BaseNavigationBarView *(^)(NSString *str,UIImage *image)) addTitleItemWithTitleAndImg;

// MARK: 根据 attributedStr 创建button 并添加到数组
- (BaseNavigationBarView *(^)(NSAttributedString *str)) addLeftItemWithAttributedStr;
- (BaseNavigationBarView *(^)(NSAttributedString *str)) addRightItemWithAttributedStr;
- (BaseNavigationBarView *(^)(NSAttributedString *str)) addTitleItemWithAttributedStr;


- (BaseNavigationBarView *) insertLeftItem: (UIButton *)button
                                    andIndex: (NSInteger)index;
- (BaseNavigationBarView *) insertRightItem: (UIButton *)button
                                     andIndex: (NSInteger)index;

- (BaseNavigationBarView *) removeLeftItemWithIndex: (NSInteger) index;
- (BaseNavigationBarView *) removeRightItemWithIndex: (NSInteger) index;
- (BaseNavigationBarView *) removeLeftAll;
- (BaseNavigationBarView *) removeRightAll;

#pragma mark - 点击事件
/** 点击了左边的按钮 */
- (void) clickLeftButtonFunc: (CliekNavItem) clickLeftItem;
/** 点击了右边的按钮 */
- (void) clickRightButtonFunc: (CliekNavItem) clickRightItem;
/** 点击了中间title的按钮 */
- (void) clickTitleButtonFunc: (ClickNavTitle) clickTitle;

#pragma layout
/** 整体布局的edg */
@property (nonatomic,assign) UIEdgeInsets itemsEdge;

/** item 之间最小的间距 默认为14pt */
@property (nonatomic,assign) CGFloat itemsMinMargin;

/** item 的高度 默认为24pt */
@property (nonatomic,assign) CGFloat itemHeight;
/**item 的最小宽度 默认为44*/
@property (nonatomic,assign) CGFloat itemMinWidth;
/** titleButton 的size */
@property (nonatomic,assign)CGFloat  titleButtonWidth;
@property (nonatomic,assign) CGFloat titleButtonHeight;

- (UIButton *) getLeftItemWithIndex: (NSInteger) index;
- (UIButton *) getRightItemWithIndex: (NSInteger) index;

#pragma mark - bottom line
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,assign) BOOL isHiddenBottomLine;
/// bottomLineH
@property (nonatomic,assign) CGFloat bottomLineH;
@property (nonatomic,assign) CGFloat bottomLineRightSpacing;
@property (nonatomic,assign) CGFloat bottomLineLeftSpacing;

#pragma mark - 阴影
@property (nonatomic,assign) BOOL isHiddenShadow;
@property (nonatomic,strong) CALayer *shadowLayer;


@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *leftItemTextFont;
@property (nonatomic,strong) UIFont *rightItemTextFont;

/// item 子view 的对齐方式
@property (nonatomic,assign) UIControlContentVerticalAlignment leftVericalAlignment;
@property (nonatomic,assign) UIControlContentVerticalAlignment rightVericalAlignment;
@property (nonatomic,assign) UIControlContentVerticalAlignment titleVericalAlignment;

@property (nonatomic,assign) UIControlContentHorizontalAlignment leftHorizontalAlignment;
@property (nonatomic,assign) UIControlContentHorizontalAlignment rightHorizontalAlignment;
@property (nonatomic,assign) UIControlContentHorizontalAlignment titleHorizontalAlignment;

@end
