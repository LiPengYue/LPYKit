//
//  PYHandleDate.h
//  Prome
//
//  Created by 李鹏跃 on 17/2/14.
//  Copyright © 2017年 品一. All rights reserved.
//

#import <Foundation/Foundation.h>

/**枚举，表示返回的是早或晚些的时间*/
typedef enum : NSUInteger {
    PYHandleCompareType_returnLittle,//返回较晚时间
    PYHandleCompareType_returnLong,//返回较早时间
} PYHandleCompareType;

/**日历默认为 公历 */
@interface PYDateManager : NSObject

//单利
+ (instancetype) shared;

/**返回较晚的时间*/
+ (NSDate *)handleDaterRturnLaterDateWithData: (NSObject *)date andOtherDate: (NSObject *)otherDate andCompareType: (PYHandleCompareType)compareType;

/**
 * 默认为公历
 NSCalendarIdentifierGregorian         公历
 NSCalendarIdentifierBuddhist          佛教日历
 NSCalendarIdentifierChinese           中国农历
 NSCalendarIdentifierHebrew            希伯来日历
 NSCalendarIdentifierIslamic           伊斯兰日历
 NSCalendarIdentifierIslamicCivil      伊斯兰教日历
 NSCalendarIdentifierJapanese          日本日历
 NSCalendarIdentifierRepublicOfChina   中华民国日历（台湾）
 NSCalendarIdentifierPersian           波斯历
 NSCalendarIdentifierIndian            印度日历
 NSCalendarIdentifierISO8601           ISO8601
 */
- (void) setUpCalenderWithEnum: (NSCalendarIdentifier) type;
/**
 * 关于时间与当前时间 比较早晚 的方法
 * date_OBJ : 传入一个字符串或者时间对象
 */
- (BOOL)isLateCurrentDateWithDate: (NSObject *)date_OBJ andDateForMatter: (NSString *)dateForMatter;



/**
 * 传入一个对象 获取对应的时间
 * date 对象（将被转化成时间对象）
 * dateFormatter 时间格式
 * dateBlock 转化成时间后的年月日
 */
#pragma mark - 获取时间的年月日
- (void)getDate: (NSObject *)getDate andDateFormatter: (NSString *)dateFormatter andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second))dateBlock;



/**
 * 关于对象转化成对象的方法
 * date_OBJ: 一个对象
 * 如果 转化失败，那么返回nil，并打印无法转化
 */
- (NSDate *)returnDateWithOBJ: (NSObject *)date_OBJ andDateFormatter: (NSString *)dateFormatterStr;



/**
 * 关于两个时间差的方法
 * CompareDate: 比较的 第一个时间
 * forcedCompareDate: 比较的第二个时间
 * block返回的是第一个时间 减去第二个时间
 
 */
#pragma mark - 两个时间相比的差值
- (void)compareDateWithDateFormatter: (NSString *)dateFormatter andCompareDate: (NSObject *)startTime andSecondCompareDate: (NSObject *)endTime andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second,NSString *dateStr))dateBlock;
@end
