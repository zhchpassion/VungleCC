//
//  VCCWeatherFetcher.h
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/10.
//

#import <Foundation/Foundation.h>
#import "VCCWeather.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^VCCWFCompletionHandler)(BOOL, VCCWeather *_Nullable, NSError *_Nullable);

@interface VCCWeatherFetcher : NSObject

- (void)getWeatherWithCompletionHandler:(nullable VCCWFCompletionHandler)complete;

@end

NS_ASSUME_NONNULL_END
