//
//  VCCWeather.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCWeather.h"

@implementation VCCWeather

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super initWithParameters:parameters]) {
        NSString *name = [parameters objectForKey:@"name"];
        if (name != nil && [name isKindOfClass:NSString.class]) {
            _name = name;
        }
        NSDictionary *dict = [parameters objectForKey:@"main"];
        if (dict && [dict isKindOfClass:NSDictionary.class]) {
            _main = [[VCCMain alloc] initWithParameters:dict];
        }
        dict = [parameters objectForKey:@"sys"];
        if (dict && [dict isKindOfClass:NSDictionary.class]) {
            _sys = [[VCCSys alloc] initWithParameters:dict];
        }
        dict = [parameters objectForKey:@"coord"];
        if (dict && [dict isKindOfClass:NSDictionary.class]) {
            _coord = [[VCCCoord alloc] initWithParameters:dict];
        }
        dict = [parameters objectForKey:@"wind"];
        if (dict && [dict isKindOfClass:NSDictionary.class]) {
            _wind = [[VCCWind alloc] initWithParameters:dict];
        }
        NSNumber *num = [parameters objectForKey:@"dt"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _date = [self dateWithUTC:num.doubleValue];
            _localDateString = [self stringFromDate:_date];
        }
    }
    return self;
}

- (NSDate *)dateWithUTC:(NSTimeInterval)utc {
    return [NSDate dateWithTimeIntervalSince1970:utc];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone localTimeZone]];
    [df_local setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
    return [df_local stringFromDate:date];
}


@end
