//
//  VCCWeatherFetcher.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/10.
//

#import "VCCWeatherFetcher.h"

@implementation VCCWeatherFetcher

- (void)getWeatherWithCompletionHandler:(VCCWFCompletionHandler)complete {
    NSLog(@"weather fetch code");
    if (complete) {
        complete(YES, [VCCWeather new], nil);
    }
}

@end
