//
//  VCCSys.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "VCCSys.h"

/*
 @property (nonatomic, assign) NSInteger ID;
 @property (nonatomic, copy) NSString *country;
 @property (nonatomic, assign) NSInteger sunrise;
 @property (nonatomic, assign) NSInteger sunset;
 @property (nonatomic, assign) NSInteger type;
 */

@implementation VCCSys

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super initWithParameters:parameters]) {
        NSString *country = [parameters objectForKey:@"country"];
        if (country && [country isKindOfClass:NSString.class]) {
            _country = country;
        }
        NSNumber *num = [parameters objectForKey:@"id"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _ID = [num integerValue];
        }
        num = [parameters objectForKey:@"sunrise"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _sunrise = [num integerValue];
        }
        num = [parameters objectForKey:@"sunset"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _sunset = [num integerValue];
        }
        num = [parameters objectForKey:@"type"];
        if (num && [num isKindOfClass:NSNumber.class]) {
            _type = [num integerValue];
        }
    }
    return self;
}

@end
