//
//  SpecialsCountDownManager.m
//  yiapp
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import "CountDownHandler.h"
#import <objc/runtime.h>

CGFloat STATIC_CURRENT_TIME_DIFFERENCE = 0;
NSDate *STATIC_APPLICATION_DID_ENTER_BACKGROUND = nil;
NSDate *STATIC_APPLICATION_DID_BECOME_ACTIVE = nil;

static NSString *const K_countDownHandler_startCountDown = @"K_countDownHandler_startCountDown";


@interface CountDownHandler()
@property (nonatomic,strong) NSMutableArray <id<CountDownHandlerViewDelegate>>*delegates;
@property (nonatomic,strong) NSMutableArray <id<CountDownHandlerDataSource>>*dataSources;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation CountDownHandler

+ (void)applicationDidBecomeActiveWithCurrentDate:(NSDate *)date {
    STATIC_APPLICATION_DID_BECOME_ACTIVE = date;
    STATIC_CURRENT_TIME_DIFFERENCE = -1;
}
+ (void) applicationDidEnterBackgroundWithCurrentDate: (NSDate *)date {
    STATIC_APPLICATION_DID_ENTER_BACKGROUND = date;
    STATIC_CURRENT_TIME_DIFFERENCE = -1;
}

+ (NSInteger)timeDifferent {
    if (STATIC_CURRENT_TIME_DIFFERENCE <= 0) {
        STATIC_CURRENT_TIME_DIFFERENCE = STATIC_APPLICATION_DID_BECOME_ACTIVE.timeIntervalSince1970 - STATIC_APPLICATION_DID_ENTER_BACKGROUND.timeIntervalSince1970;
    }
    return STATIC_CURRENT_TIME_DIFFERENCE;
}

- (instancetype) init {
    if (self = [super init]) {
        self.timeInterval = 1;
        self.currentTime = 0;
        self.targetMaxCount = 100;
    }
    return self;
}

- (void) start {
    if (!self.timer) {
        [self createTimer];
    }
}
- (void) end {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void) registerCountDownEventWithDataSources:(NSArray<id<CountDownHandlerDataSource>> *)dataSources {
    __weak typeof (self)weakSelf = self;
    [dataSources enumerateObjectsUsingBlock:^(id<CountDownHandlerDataSource>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf registerCountDownEventWithDataSource:obj];
    }];
}
- (void) registerCountDownEventWithDataSource:(id<CountDownHandlerDataSource>)dataSource {
    
    if (!dataSource) {
        return;
    }
    __weak typeof(dataSource) weakDataSource = dataSource;
    __weak typeof(self) weakSelf = self;
    if ([self getDataSourceStartCountDownTime:weakDataSource] < 0) {
        [self setDataSourceStartCountDownTime:weakDataSource];
    }
    if([weakDataSource respondsToSelector:@selector(countDownHandler:andDataSourceCurrenUntil:)]) {
        CGFloat currentUntil = weakSelf.currentTime - [weakSelf getDataSourceStartCountDownTime:weakDataSource];
        [weakDataSource countDownHandler:weakSelf andDataSourceCurrenUntil:currentUntil];
    }
    if ([self.dataSources containsObject:dataSource]) {
        return;
    }
  
    [self lock:^{
        [weakSelf.dataSources addObject:dataSource];
    }];
}

- (void)registerCountDownEventWithDelegates:(NSArray<id<CountDownHandlerViewDelegate>> *)delegates {
    __weak typeof(self)weakSelf = self;
    [delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf registerCountDownEventWithDelegate:obj];
    }];
}
- (void) registerCountDownEventWithDelegate: (id <CountDownHandlerViewDelegate>)delegate{
    if (!delegate) {
        NSLog(@".\
              \n   🌶：【%@】注册代理失败，代理为nil\
              \n   🌶： 如果出现倒计时复用问题:\
              \n     必须要在`registerCountDownEventWithDelegate`之前，保证delegate数据源存在\
              \n   也就是确保`getViewDelegateMapDataSource`可以获取到正确的值\
              \n.",NSStringFromClass([self class]));
        return;
    }
    __weak typeof(delegate) weakDelegate = delegate;
    __weak typeof(self) weakSelf = self;
    if([weakDelegate respondsToSelector:@selector(countDownHandler:andDataSource:)]) {
        id <CountDownHandlerDataSource> dataSource;
        if([weakDelegate respondsToSelector:@selector(getViewDelegateMapDataSource)]) {
            [weakSelf registerCountDownEventWithDataSource:dataSource];
            
            dataSource = [weakDelegate getViewDelegateMapDataSource];
            
            if (!dataSource) {
                [weakSelf logError_NotDataSource];
            }
            if ([dataSource respondsToSelector:@selector(countDownHandler:andDataSourceCurrenUntil:)]) {
                CGFloat currentUntil = weakSelf.currentTime - [weakSelf getDataSourceStartCountDownTime:dataSource];
                [dataSource countDownHandler:weakSelf andDataSourceCurrenUntil:currentUntil];
            }
        }
        [weakDelegate countDownHandler:weakSelf andDataSource:dataSource];
    }
    if ([self.delegates containsObject:delegate]) {
        return;
    }
    
    if (self.delegates.count > self.targetMaxCount) {
        [self removeDelegate:self.delegates.firstObject];
    }
    
    [self lock:^{
        [weakSelf.delegates addObject:weakDelegate];
    }];
}

- (void) removeDelegate: (id)delegate {
    if (!delegate) {
        NSLog(@"\n🌶：【%@】注册代理失败，代理为nil\n",NSStringFromClass([self class]));
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self lock:^{
        [weakSelf.delegates removeObject: delegate];
    }];
}
- (void)removeDataSource:(id<CountDownHandlerDataSource>)dataSource {
    if (!dataSource) {
        NSLog(@"\n🌶：【%@】注册代理dataSource，dataSource为nil\n",NSStringFromClass([self class]));
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self lock:^{
        [weakSelf.dataSources removeObject:dataSource];
    }];
}

- (void)timerAction {
    [self lock:^{
        self.currentTime += self.timeInterval;
        __weak typeof (self)weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj respondsToSelector:@selector(countDownHandler:andDataSource:)]) {
                    id <CountDownHandlerDataSource>dataSource;
                    if ([obj respondsToSelector:@selector(getViewDelegateMapDataSource)]) {
                        dataSource = [obj getViewDelegateMapDataSource];
                    }
                    if ([dataSource respondsToSelector:@selector(countDownHandler:andDataSourceCurrenUntil:)]) {
                        CGFloat currentUntil = weakSelf.currentTime - [weakSelf getDataSourceStartCountDownTime:dataSource];
                        [dataSource countDownHandler:weakSelf andDataSourceCurrenUntil:currentUntil];
                    }
                    [obj countDownHandler:weakSelf andDataSource:dataSource];
                }
            }];
        });
    }];
}

- (void) lock: (void(^)(void))block {
//    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (block) {
        block();
    }
//    dispatch_semaphore_signal(self.semaphore);
}

- (void) createTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = _timer;
    /*
     第一个参数:定时器对象
     第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
     第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
     第四个参数:精准度(表示允许的误差,0表示绝对精准)
     */
    dispatch_time_t t = self.isStopWithBackstage ? DISPATCH_TIME_NOW : dispatch_walltime(NULL,0);
    t = dispatch_walltime(NULL,0);
//    dispatch_source_set_timer(self.timer, t, self.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf timerAction];
    });
    dispatch_resume(self.timer);
}

- (void)dealloc {
    NSLog(@"✅销毁：%@",NSStringFromClass([self class]));
}

- (NSArray *) getCurrentDelegates {
    return self.delegates.copy;
}
- (NSArray *) getCurrentDataSource {
    return self.dataSources.copy;
}

- (void) removeAllDelegate {
    __weak typeof(self)weakSelf = self;
    [self.delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerViewDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf removeDelegate:obj];
    }];
}
- (void)removeAllDataSource {
    __weak typeof(self)weakSelf = self;
    [self lock:^{
        [weakSelf.dataSources removeAllObjects];
    }];
}

// MARK: - get && set
- (NSMutableArray <id<CountDownHandlerViewDelegate>>*) delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray new];
    }
    return _delegates;
}
- (NSMutableArray <id<CountDownHandlerDataSource>> *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray new];
    }
    return _dataSources;
}
- (dispatch_semaphore_t) semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}
//
//- (void) setDelegateStartCountDownTime: (id<CountDownHandlerViewDelegate>)delegate {
//    if (!delegate) return;
//    objc_setAssociatedObject(delegate, &K_countDownHandler_startCountDown, @(self.currentTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (CGFloat) getDelegateStartCountDownTime: (id<CountDownHandlerViewDelegate>)delegate {
//    NSNumber *obj = objc_getAssociatedObject(delegate, &K_countDownHandler_startCountDown);
//    if (![obj isKindOfClass:[NSNumber class]]) {
//        return -1;
//    }
//    return obj.integerValue;
//}

- (void) setDataSourceStartCountDownTime: (id<CountDownHandlerDataSource>)dataSource {
    if (!dataSource) return;
    objc_setAssociatedObject(dataSource, &K_countDownHandler_startCountDown, @(self.currentTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat) getDataSourceStartCountDownTime: (id<CountDownHandlerDataSource>)dataSource {
    NSNumber *obj = objc_getAssociatedObject(dataSource, &K_countDownHandler_startCountDown);
    if (![obj isKindOfClass:[NSNumber class]]) {
        return -1;
    }
    return obj.integerValue;
}

- (void) logError_NotDataSource {
    
        NSLog(@".\
              \n   🌶：【%@】注册代理失败，代理为nil\
              \n   🌶： 如果出现倒计时复用问题，必须要在`registerCountDownEventWithDelegate`之前，保证delegate数据源存在\
              \n   也就是确保`getViewDelegateMapDataSource`可以获取到正确的值\
              \n.",NSStringFromClass([self class]));
}
@end
