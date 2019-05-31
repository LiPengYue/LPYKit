//
//  PYHandleDate.m
//  Prome
//
//  Created by 李鹏跃 on 17/2/14.
//  Copyright © 2017年 品一. All rights reserved.
//

#import "PYDateManager.h"

@interface PYDateManager ()
@property (nonatomic,strong)NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@end

@implementation PYDateManager
//单利
static PYDateManager *_instancetype;
+ (instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instancetype = [[self alloc]init];
        _instancetype.dateFormatter = [[NSDateFormatter alloc]init];
    });
    return _instancetype;
}

- (void) setUpCalenderWithEnum: (NSCalendarIdentifier) type {
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:type];
}

#pragma mark - 返回较晚(或较早时间)的时间
+ (NSDate *)handleDaterRturnLaterDateWithData: (NSObject *)date andOtherDate: (NSObject *)otherDate andCompareType: (PYHandleCompareType)compareType {
    NSDate *dateOne = [[self shared] returnDateWithOBJ:date andDateFormatter:nil];
    NSDate *dateTwo = [[self shared] returnDateWithOBJ:otherDate andDateFormatter:nil];
    //返回时间对象
    NSDate *returnDate;
    if (compareType == PYHandleCompareType_returnLittle) {
        returnDate = [dateOne laterDate:dateTwo];
    }else {
        returnDate = [dateOne earlierDate:dateTwo];
    }
    return returnDate;
}


#pragma mark - 比较当前时间与传入时间的方法
- (BOOL)isLateCurrentDateWithDate: (NSObject *)date_OBJ andDateForMatter: (NSString *)dateForMatter{
    
    NSDate *compareDate = [self returnDateWithOBJ:date_OBJ andDateFormatter:dateForMatter];
    //2、表示事件格式转化完毕 比较时间
    //1.0 获取当前时间
    NSDate *currentDate = [[NSDate alloc]init];
    //2.0 比较时间
    //NSOrderedAscending 升序
    // NSOrderedSame 相同
    // NSOrderedDescending 降序
    //升序表示比现在事件要晚
    BOOL isTrue = [currentDate compare:compareDate] == NSOrderedAscending;
    return isTrue;
}


#pragma mark - 获取时间的年月日
- (void)getDate: (NSObject *)getDate andDateFormatter: (NSString *)dateFormatter andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second))dateBlock{
    
    if (!dateFormatter){
        dateFormatter = @"yyyy-MM-dd HH:mm:ss";
    }
    
    //1.时间
    NSDate *get_Date = [self returnDateWithOBJ:getDate andDateFormatter:dateFormatter];
    
    
    //3.判断是否为时间对象
    if (!get_Date) {
        NSLog(@"传入的对象转化时间对象失败");
        return;
    }
    
    //4.引入当前的日历
    NSCalendar *crrentCalender = self.calendar;
    
    //5.通过日历 创建NSDateComponents
    //里面储存了对应的年月日 compareDate的
    NSDateComponents *compareDateComponents = [crrentCalender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:get_Date];
    
    //年
    NSInteger year = compareDateComponents.year;
    //月
    NSInteger month = compareDateComponents.month;
    //日
    NSInteger day = compareDateComponents.day;
    //时
    NSInteger hour = compareDateComponents.hour;
    //分
    NSInteger minute = compareDateComponents.minute;
    //秒
    NSInteger second = compareDateComponents.second;
    
    //7. 比较并返回结果
    if (dateBlock) {
        dateBlock(year,month,day,hour,minute,second);
    }
}




#pragma mark - 转化把对象转化成时间对象的方法
- (NSDate *)returnDateWithOBJ: (NSObject *)date_OBJ andDateFormatter: (NSString *)dateFormatterStr{
    
    
    if (!dateFormatterStr){
        dateFormatterStr = @"yyyy-MM-dd HH:mm:ss";
    }
    
    //1. 把字符串 转化成事件对象
    //1.0 时间格式化对象
    NSDateFormatter *dateFormatter = self.dateFormatter;
    dateFormatter.dateFormat = dateFormatterStr;
    NSString *dateStr = nil;
    NSDate *date = nil;
    if ([date_OBJ isKindOfClass:[NSString class]]){//是字符串
        dateStr = (NSString *)date_OBJ;
        //假设是时间字符串可以直接转化成时间对象
        date = [self.dateFormatter dateFromString:dateStr];
        if (!date){//如果没有转化成功，按NSNumber类型处理
            date = [NSDate dateWithTimeIntervalSince1970:dateStr.integerValue];
            dateStr = [self.dateFormatter stringFromDate:date];
            date = [self.dateFormatter dateFromString:dateStr];
        }
        
    }else if ([date_OBJ isKindOfClass: [NSDate class]]){
        date = (NSDate *)date_OBJ;
        dateStr = [self.dateFormatter stringFromDate:date];
        date = [self.dateFormatter dateFromString:dateStr];
        
    }else if ([date_OBJ isKindOfClass:[NSNumber class]]){
        NSNumber *dateNumber = (NSNumber *)date_OBJ;
        NSInteger timeIntercal = dateNumber.integerValue;
        date = [NSDate dateWithTimeIntervalSince1970:timeIntercal];
        dateStr = [self.dateFormatter stringFromDate:date];
        date = [self.dateFormatter dateFromString:dateStr];
        
    }else{
        NSLog(@"传入的date_OBJ对象不能被识别 我可以识别 日期的NSString,NSNumber,NSDate");
        return nil;
    }
    if (!date) {
        NSLog(@"传入的对象不能被转化成时间对象");
    }
    return date;
}



#pragma mark - 两个时间相比的差值并返回字符串
- (void) getComponentsWithDateFormatter: (NSString *)dateFormatter andCompareDate: (NSObject *)startTime andSecondCompareDate: (NSObject *)endTime andBlock: (void(^)(NSDateComponents *components))block {
    if (!block) return;
    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        NSString *dateFormatterStr = dateFormatter;
        if (!dateFormatterStr){
            dateFormatterStr = @"yyyy-MM-dd HH:mm:ss";
        }
        
        //1；保证格式统一
        NSDateFormatter *dateFomatter = self.dateFormatter;
        dateFomatter.dateFormat = dateFormatterStr;
        
        NSDate *startDateTemp = [self returnDateWithOBJ:(NSObject *)startTime andDateFormatter:dateFormatterStr];
        
        // 截止时间data格式
        NSDate *endDateTemp = [self returnDateWithOBJ:endTime andDateFormatter:dateFormatterStr];
        // 开始时间data格式如果没有传入 那么默认是当前时间
        if (!endDateTemp) {
            endDateTemp = [NSDate dateWithTimeIntervalSinceNow:0];
            endDateTemp = [self returnDateWithOBJ:endDateTemp andDateFormatter:dateFormatterStr];
        }
        
        // 开始时间字符串格式
        NSString *startDateStr = [dateFomatter stringFromDate:startDateTemp];
        // 截止时间字符串格式
        NSString *endDateStr = [dateFomatter stringFromDate:endDateTemp];
        //转成统一的格式
        NSDate *nowDate = [dateFomatter dateFromString:startDateStr];
        NSDate *expireDate = [dateFomatter dateFromString:endDateStr];
        
        //2. 比较数据
        // 当前日历
        NSCalendar *calendar = self.calendar;
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 对比时间差
        NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:NSCalendarWrapComponents ];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(dateCom);
        });
    });
}
- (void)compareDateWithDateFormatter: (NSString *)dateFormatter andCompareDate: (NSObject *)startTime andSecondCompareDate: (NSObject *)endTime andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second,NSString *dateStr))dateBlock {
    if (!dateBlock) return;
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        
        
        __block NSDateComponents *dateCom;
        //    [self getComponentsWithDateFormatter:dateFormatterStr andCompareDate:startTime andSecondCompareDate:endTime andBlock:^(NSDateComponents *components) {
        //        dateCom = components;
        //    }];
        NSString * dateFormatterStr = dateFormatter;
        if (!dateFormatterStr){
            dateFormatterStr = @"yyyy-MM-dd HH:mm:ss";
        }
        
        //1；保证格式统一
        NSDateFormatter *dateFomatter = self.dateFormatter;
        dateFomatter.dateFormat = dateFormatterStr;
        
        NSDate *startDateTemp = [self returnDateWithOBJ:(NSObject *)startTime andDateFormatter:dateFormatterStr];
        
        // 截止时间data格式
        NSDate *endDateTemp = [self returnDateWithOBJ:endTime andDateFormatter:dateFormatterStr];
        // 开始时间data格式如果没有传入 那么默认是当前时间
        if (!endDateTemp) {
            endDateTemp = [NSDate dateWithTimeIntervalSinceNow:0];
            endDateTemp = [self returnDateWithOBJ:endDateTemp andDateFormatter:dateFormatterStr];
        }
        
        // 开始时间字符串格式
        NSString *startDateStr = [dateFomatter stringFromDate:startDateTemp];
        // 截止时间字符串格式
        NSString *endDateStr = [dateFomatter stringFromDate:endDateTemp];
        //转成统一的格式
        NSDate *nowDate = [dateFomatter dateFromString:startDateStr];
        NSDate *expireDate = [dateFomatter dateFromString:endDateStr];
        
        //2. 比较数据
        // 当前日历
        NSCalendar *calendar = self.calendar;
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 对比时间差
        dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:NSCalendarWrapComponents ];
        
        //年
        NSInteger year = dateCom.year;
        //月
        NSInteger month = dateCom.month;
        //日
        NSInteger day = dateCom.day;
        //时
        NSInteger hour = dateCom.hour;
        //分
        NSInteger minute = dateCom.minute;
        //秒
        NSInteger second = dateCom.second;
        
        // 比较并返回结果
        
        
        //    年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
        
        
        NSString *str;
        if (year != 0) {
            str = [NSString stringWithFormat:@"%zd年%zd月%zd天%zd小时%zd分%zd秒",year,month,day,hour,minute,second];
        }else if(year == 0 && month != 0) {
            str = [NSString stringWithFormat:@"%zd月%zd天%zd小时%zd分%zd秒",month,day,hour,minute,second];
        }else if (year == 0 && month == 0 && day != 0){
            str = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒",day,hour,minute,second];
        }else if (year == 0 && month == 0 && day == 0 && hour != 0){
            str = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",hour,minute,second];
        }else if (year == 0 && month == 0 && day == 0 && hour != 0){
            str = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",hour,minute,second];
        }else if (year == 0 && month == 0 && day == 0 && hour == 0 && minute!=0) {
            str = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
        }else{
            str = [NSString stringWithFormat:@"%zd秒",second];
        }
        
        //    NSString *dateString = nil;
        //    if (year) {
        //        dateString = [NSString stringWithFormat:@"%zd/%02zd/%02zd",year,month,day];
        //    }else if (month) {
        //        dateString = [NSString stringWithFormat:@"%zd月之前",month];
        //    }else if (day) {
        //        dateString = [NSString stringWithFormat:@"%zd天前",day];
        //    }else if (hour) {
        //        dateString = [NSString stringWithFormat:@"%zd小时前",hour];
        //    }else if (minute) {
        //        if (minute > 30) {
        //            dateString = [NSString stringWithFormat:@"1小时内"];
        //        }else if(minute > 1){
        //            dateString = [NSString stringWithFormat:@"%zd分钟内",minute];
        //        }else {
        //            dateString = [NSString stringWithFormat:@"刚刚"];
        //        }
        //    }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dateBlock) {
                dateBlock(year,month,day,hour,minute,second,str);
            }
        });
    });
}


/**
 * 开始到结束的时间差
 */
#pragma mark - 比较两个时间并且返回字符串
- (NSString *)compareDateGapWithCompareDate: (NSObject *)startTime andSecondCompareDate: (NSObject *)endTime andDateFormatter: (NSString *)dateFormatter{
    
    NSDateFormatter *date = self.dateFormatter;
    [date setDateFormat:dateFormatter];
    
    NSDate *startD =[self returnDateWithOBJ:startTime andDateFormatter:dateFormatter];
    NSDate *endD = [self returnDateWithOBJ:endTime andDateFormatter:dateFormatter];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    return str;
    
}

// MARK: - get && set
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}
@end

