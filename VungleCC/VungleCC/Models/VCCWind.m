//
//  VCCWind.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCWind.h"

@implementation VCCWind

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super initWithParameters:parameters]) {
        NSNumber *num = [parameters objectForKey:@"deg"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _deg = [num integerValue];
        }
        num = [parameters objectForKey:@"speed"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _speed = [num doubleValue];
        }
        num = [parameters objectForKey:@"gust"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _gust = [num doubleValue];
        }
    }
    return self;
}

@end
