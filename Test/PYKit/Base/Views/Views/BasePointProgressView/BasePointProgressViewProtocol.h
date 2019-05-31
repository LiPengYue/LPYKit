//
//  BasePointProgressViewProtocol.h
//  BaseProgress
//
//  Created by 衣二三 on 2019/4/9.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 让节点高亮的策略
typedef enum : NSUInteger {
    /// 到达 节点中心才算高亮
    BasePointProgressSelectedCenter,
    /// 到达 节点边缘
    BasePointProgressSelectedEdge,
} EBasePointProgressSelectedType;

typedef EBasePointProgressSelectedType EBasePointProgressSelectedType;
struct BasePointProgressLineData {
    UIColor *lineColor;
    /// 线的center y 值
    CGFloat lineScaleY;
    CGFloat lineHeight;
    /// 连续绘制几个单位长度
    CGFloat drowLength;
    /// 连续空白几个单位长度
    CGFloat marginLength;
    /// 线的层级 是否在pointView之上
    BOOL isMovePointViewTop;
};
typedef struct BasePointProgressLineData BasePointProgressLineData;

//// 创建高亮状态下的默认显示
NS_INLINE BasePointProgressLineData BasePointProgressLineDataMakeHighlightDefult() {
    BasePointProgressLineData defult;
//    defult.lineLeftSpacing = 0;
//    defult.lineRightSpacing = 0;
    defult.lineScaleY = 0.5;
    defult.lineHeight = 2;
    defult.lineColor = [UIColor colorWithRed:0.956862745 green:0.470588235 blue:0.447058824 alpha:1];
    defult.marginLength = 0;
    return defult;
}


/// 创建 默认情况下的默认值
NS_INLINE BasePointProgressLineData BasePointProgressLineDataMakeNormalDefult() {
    BasePointProgressLineData defult;
    defult.lineScaleY = 0.5;
    defult.lineHeight = 1;
//    defult.lineLeftSpacing = 0;
//    defult.lineRightSpacing = 0;
    CGFloat colorValue = 175.0 / 255.0;
    defult.lineColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1];
    defult.marginLength = 0;
    return defult;
}


@class BasePointProgressView,BasePointProgressContentView;
@protocol BasePointProgressProtocol <NSObject>



/// 创建 节点的view
- (NSArray <BasePointProgressContentView *> *) createPointContentViewWithProgressView: (BasePointProgressView *)progressView;


/**
 将要显示的时候调用 可以在这里设置pointView

 @param pointView pointView
 @param isSelected 是否应该高亮显示
 @param index pointView的位置
 */
- (void) willDisplayPointView: (BasePointProgressContentView *) pointView
                  andIsSected: (BOOL) isSelected
                     andIndexPath: (NSInteger)index;


/**
 /// 动画结束后
 */

- (void) animationDidStopWithProgressView: (BasePointProgressView *)progressView
                    andSelectedPointViews: (NSArray <BasePointProgressContentView *>*) selectedPointViews
                      andNormalPointViews: (NSArray <BasePointProgressContentView *>*)normalPointViews;

/// 托转currentProgressView的时候回调
- (void) panChangedWithProgressView: (BasePointProgressView *)progressView
              andSelectedPointViews: (NSArray <BasePointProgressContentView *>*) selectedPointViews
                andNormalPointViews: (NSArray <BasePointProgressContentView *>*)normalPointViews;
@end


@interface BasePointProgressViewProtocol : NSObject

@end

