//
//  VCCCoord.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCCoord.h"

@implementation VCCCoord

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super initWithParameters:parameters]) {
        NSNumber *num = [parameters objectForKey:@"lon"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _lon = [num doubleValue];
        }
        num = [parameters objectForKey:@"lat"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _lat = [num doubleValue];
        }
    }
    return self;
}

@end
