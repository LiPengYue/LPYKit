//
//  SpecialsCountDownManager.h
//  yiapp
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYDateManager.h"

/**
 * CountDownHandler 有两种代理
 > 1. 利用`registerCountDownEventWithDataSources` 储存modelArray
  其中modelArray中的model必须继承CountDownHandlerDataSource代理
  在储存modelArray数组时，会向model中添加一个CGFlaot属性（countDownHandler_startCountDown），用来记录此时 CountDownHandler 计时器已经计时时间（currentTime）。
  countDownHandler_startCountDown： 在计算剩余倒计时时间时，会用到。 剩余时间 = model的总倒计时时间-(CountDownHandler.currentTime - countDownHandler_startCountDown);
 
 > 2. 利用`CountDownHandlerViewDelegate`刷新UI

 
 */


/**
 倒计时工具
 @warning  需要自行保证CountDownHandler生命周期
 @warning  如果需求为 tableView的cell中有倒计时:
 
 1. 必须 在数据源数组的set方法中 调用`registerCountDownEventWithDataSources`方法，进行model的批量注册，无需判断是否重复注册，方法内部进行了排除
 
 2. 在model需要实现`CountDownHandlerDataSource`相关代理方法,进行倒计时计算

 3. 在tableView中持有`CountDownHandler`，并且需要在`tableView`的`DataSource`方法`cellFroRowAtIndexPath`中,调用 `registerCountDownEventWithDelegate`，把cell，作为delegate，在代理方法中修改UI
 */

@class CountDownHandler;
@protocol CountDownHandlerDataSource;


/** 针对于视图的delegate方法 */
@protocol CountDownHandlerViewDelegate<NSObject>
/**
 在每次倒计时事件触发后调用与调用`registerCountDownEventWithDelegate`后都会触发代理方法`- (void) countDownHandler: (CountDownHandler *)handler andDataSource: (id <CountDownHandlerDataSource>)dataSource;`
 */
- (void) countDownHandler: (CountDownHandler *)handler andDataSource: (id <CountDownHandlerDataSource>)dataSource;

/**
 获取视图所对应的Model
 @return model
 */
- (id <CountDownHandlerDataSource>) getViewDelegateMapDataSource;
@end



/** 针对于model的delegate方法 */
@protocol CountDownHandlerDataSource<NSObject>

/**
 当需要这条数据显示的时候，会进行调用

 @param handler handler
 @param until 当前已经倒计时了多少时间【剩余时间 = 倒计时总时间 - until】
 */
- (void) countDownHandler: (CountDownHandler *)handler andDataSourceCurrenUntil: (CGFloat)until;
@end

@interface CountDownHandler : NSObject

/**
 倒计时 时间 间隔 （秒单位） 默认为1
 */
@property (nonatomic, assign) CGFloat timeInterval;

/**
  现在已经进行时间 (负数 秒单位) 默认为0
 */
@property (nonatomic, assign) CGFloat currentTime;

/**
 最多同时存在多少个需要倒计时的model
 @warning 最好是两个屏幕所能盛放的cell的数量）， 默认为100
 */
@property (nonatomic, assign) NSInteger targetMaxCount;

/**
 开始倒计时 创建 dispatch_source_t
 */
- (void) start;

/**
 结束倒计时 把timer赋值为nil 不会删除所需要倒计时的model
 */
- (void) end;

/**
 注册倒计时事件
 @bug 注册事件前，需要确保 delegate 中有正确的数据源，否则会数据错乱
 */
- (void) registerCountDownEventWithDelegate: (id <CountDownHandlerViewDelegate>)delegate;

/**
 批量添加delegate，

 @param dataSources dataSource数组 如果数中有元素已经添加，那么将不再添加
 @bug 在有上拉加载的需求中，如果依然 依据当前self.currentTime计算时间的话,会出现差错，因为新返回的数据，需要从0开始倒计时，而不是直接减去currentTime
 
    所以在添加到注册列表的过程中，在dataSource中记录了此时的currentTime（记做delegateCurrentTime），
 
    在进行倒计时时候，会利用currentTime - delegateCurrentTime, 得到需要真正的倒计时间
 
 @bug 需要在网络请求下来后，立即把modelArray注册到dataSources中，以保倒计时准确
 */
- (void)registerCountDownEventWithDataSources: (NSArray<id <CountDownHandlerDataSource>>*)dataSources;

/**
 注册单个的DataSource

 @param dataSource dataSource
 */
- (void) registerCountDownEventWithDataSource: (id<CountDownHandlerDataSource>)dataSource;
/**
 不再相应倒计时
 @param delegate 注销修改视图的delegate
 */
- (void) removeDelegate: (id)delegate;


/** 移除相应的 dataSource */
- (void) removeDataSource: (id<CountDownHandlerDataSource>)dataSource;

/**
 获取delegates
 */
- (NSArray *) getCurrentDelegates;
/**
 获取所有的dataSource
 */
- (NSArray *) getCurrentDataSource;
/**
 清除所需要倒计时的View delegate
 */
- (void) removeAllDelegate;

/**
 清除所需要倒计时的dataSource
 */
- (void) removeAllDataSource;

/**
 进入后台后，是否停止倒计时 默认为false
 */
@property (nonatomic,assign) BOOL isStopWithBackstage;

/// 进入后 又回到前台的时间差
+ (NSInteger) timeDifferent;
+ (void) applicationDidEnterBackgroundWithCurrentDate: (NSDate *)date;
+ (void) applicationDidBecomeActiveWithCurrentDate: (NSDate *)date;
@end
