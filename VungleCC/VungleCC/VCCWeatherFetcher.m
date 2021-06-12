//
//  VCCWeatherFetcher.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/10.
//

#import "VCCWeatherFetcher.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^VCCWFBuildUrlCompleteHandler)(BOOL success, NSString *_Nullable url, NSError *_Nullable error);

@interface VCCWeatherFetcher()


@end

static NSString * const kVCCOpenWeatherAppKey   = @"edfe4ace41a2a8b1b9c7b15885662313";
static NSString * const kVCCOpenWeatherBaseUrl  = @"https://api.openweathermap.org/data/2.5/weather";

@implementation VCCWeatherFetcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tempUnit = VCCWFTemperatureUnitKelvin;
    }
    return self;
}

- (void)getWeatherWithCompletionHandler:(VCCWFCompletionHandler)complete {
    [self buildRequestUrlWithCompletionHandler:^(BOOL success, NSString * _Nullable url, NSError * _Nullable error) {
        if (success) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:30.0];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    if (complete) {
                        complete(NO, nil, error);
                    }
                    return;
                }
            }];
            [task resume];
        }else {
            if (complete) {
                complete(NO, nil, error);
            }
        }
    }];
}

- (void)buildRequestUrlWithCompletionHandler:(VCCWFBuildUrlCompleteHandler)complete {
    NSString *url = [NSString stringWithFormat:@"%@?appid=%@", kVCCOpenWeatherBaseUrl, kVCCOpenWeatherAppKey];
    if (self.zipCode
        && self.zipCode.length > 0
        && self.countryCode
        && self.countryCode.length > 0) {
        url = [url stringByAppendingFormat:@"&zip=%@,%@", self.zipCode, self.countryCode];
        if (complete) {
            complete(YES, url, nil);
        }
    }else {
        // try to get geolocation
        if ([CLLocationManager locationServicesEnabled] == NO || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {// system toggled off or current app does not get authorization
            NSError *error = [self buildErrorWithCode:kVCCErrorCodeNoLocationAuthorization
                                          andErrorMsg:@"system toggled off geolocation service or current app does not get authorization"];
            if (complete) {
                complete(NO, nil, error);
            }
            return;
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            NSError *error = [self buildErrorWithCode:kVCCErrorCodeNoLocationAuthorization
                                          andErrorMsg:@"user do not determine"];
            if (complete) {
                complete(NO, nil, error);
            }
            return;
        }
    }
}

- (NSError *)buildErrorWithCode:(NSInteger)code andErrorMsg:(NSString *)msg {
    NSString *domain = @"com.Vungle.VungleCC.ErrorDomain";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : msg };
    NSError *error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:userInfo];
    return error;
}

@end
