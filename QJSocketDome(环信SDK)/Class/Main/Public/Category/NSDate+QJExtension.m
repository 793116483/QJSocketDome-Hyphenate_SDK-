//
//  NSDate+QJExtension.m
//  QJSocketDome(环信SDK)
//
//  Created by 瞿杰 on 2019/12/14.
//  Copyright © 2019 yiniu. All rights reserved.
//

#import "NSDate+QJExtension.h"

@implementation NSDate (QJExtension)

+(NSString *)dateStringWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(nonnull NSString *)dateFormat{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat ;
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"+0800"];
    return [formatter stringFromDate:date];
}

-(NSString *)customString {
    return nil ;
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:localTime/1000];
//    guard let dateStr = dateStr else {
//        return nil
//    }
//
//    let format = DateFormatter()
//    format.dateFormat = dateFormat
//    format.locale = locale
//
//    return format.date(from: dateStr)
//
//    // 现在的日期
//    NSDate * nowDate = [NSDate date];
//
//    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:date];
//    // 小于60s
//    if (timeInterval < 60) {
//        return @"刚刚";
//    }
//    else if(timeInterval < 60*60){
//        return "\(timeInterval/60)分钟前"
//    }else if(timeInterval < 60*60 * 24){
//        return "\(timeInterval/(60*60))小时前"
//    }else{
//        // 日历
//        let calendar = NSCalendar.current
//        let format = DateFormatter()
//
//        // 昨天的时间
//        if calendar.isDateInYesterday(self) {
//            format.dateFormat = "昨天 HH:mm"
//        }
//        // 在同一年内 : MM-dd HH:mm
//        else if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
//            format.dateFormat = "MM-dd HH:mm"
//        }
//        // 不同年
//        else{
//            format.dateFormat = "yyyy MM-dd HH:mm"
//        }
//
//        return format.string(from: self)
//    }
}

@end
