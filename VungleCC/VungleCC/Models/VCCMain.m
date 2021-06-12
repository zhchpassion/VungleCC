//
//  VCCMain.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCMain.h"


@implementation VCCMain

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super initWithParameters:parameters]) {
        NSNumber *num = [parameters objectForKey:@"temp_max"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _temp_max = [num doubleValue];
        }
        num = [parameters objectForKey:@"temp_min"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _temp_min = [num doubleValue];
        }
        num = [parameters objectForKey:@"temp"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _temp = [num doubleValue];
        }
        num = [parameters objectForKey:@"feels_like"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _feels_like = [num doubleValue];
        }
        num = [parameters objectForKey:@"humidity"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _humidity = [num integerValue];
        }
        num = [parameters objectForKey:@"pressure"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _pressure = [num integerValue];
        }
    }
    return self;
}

@end
