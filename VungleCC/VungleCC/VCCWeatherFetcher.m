//
//  VCCWeatherFetcher.m
//  VungleCC
//
//  Created by Chao Zhang on 2021/6/10.
//

#import "VCCWeatherFetcher.h"
#import <CoreLocation/CoreLocation.h>

const NSInteger kVCCErrorCodeNoLocationAuthorization            = -10001;
const NSInteger kVCCErrorCodeInvalidZipCode                     = -10002;
const NSInteger kVCCErrorCodeUndefined                          = -10003;

typedef void(^VCCWFBuildUrlCompleteHandler)(BOOL success, NSString *_Nullable url, NSError *_Nullable error);


static void vcc_dispatch_main_async_safe(dispatch_block_t block)
{
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@interface VCCWeatherFetcher()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, copy, nullable) VCCWFCompletionHandler completionHandler;

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
    self.completionHandler = complete;
    if (self.zipCode
        && self.zipCode.length > 0
        && self.countryCode
        && self.countryCode.length > 0) {
        [self getWeatherByZipCode];
    }else {
        [self initLocationManager];
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
            [self.locManager requestWhenInUseAuthorization];
            return;
        }
        [self.locManager startUpdatingLocation];
    }
}

- (void)getWeatherByZipCode {
    NSString *url = [NSString stringWithFormat:@"%@?appid=%@&zip=%@,%@", kVCCOpenWeatherBaseUrl, kVCCOpenWeatherAppKey, self.zipCode, self.countryCode];
    [self requestWeatherWithUrl:url];
}

- (void)getWeatherWithCLLocationLon:(double)lon andLat:(double)lat {
    NSString *url = [NSString stringWithFormat:@"%@?appid=%@&lon=%d&lat=%d", kVCCOpenWeatherBaseUrl, kVCCOpenWeatherAppKey, (int)lon, (int)lat];
    [self requestWeatherWithUrl:url];
}

- (void)initLocationManager {
    _locManager = [[CLLocationManager alloc] init];
    _locManager.delegate = self;
}

- (void)requestWeatherWithUrl:(NSString *)url {
    NSString *unit = self.tempUnit == VCCWFTemperatureUnitKelvin ? @"standard" : @"metric";
    NSString *requestUrl = [url stringByAppendingFormat:@"&units=%@", unit];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:30.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSError *e = [self buildErrorWithCode:kVCCErrorCodeUndefined
                                      andErrorMsg:@"undefined error occoured, parse network data error"];
            [self invokeBlockOnMainThreadWithSuccess:NO weather:nil andError:e];
            return;
        }
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
        if (responseDict && [responseDict isKindOfClass:NSDictionary.class]) {
            NSNumber *num = [responseDict objectForKey:@"cod"];
            if (num && [num isKindOfClass:NSNumber.class]) {
                switch (num.integerValue) {
                    case 200: {
                        VCCWeather *weather = [[VCCWeather alloc] initWithParameters:responseDict];
                        [self invokeBlockOnMainThreadWithSuccess:YES weather:weather andError:nil];
                    }
                        break;
                    case 404: {
                        NSError *e = [self buildErrorWithCode:kVCCErrorCodeInvalidZipCode
                                                  andErrorMsg:@"invalid zip code/country code"];
                        [self invokeBlockOnMainThreadWithSuccess:NO weather:nil andError:e];
                    }
                        break;
                    default: {
                        NSError *e = [self buildErrorWithCode:kVCCErrorCodeUndefined
                                                  andErrorMsg:@"undefined error occoured, parse network data error"];
                        [self invokeBlockOnMainThreadWithSuccess:NO weather:nil andError:e];
                    }
                        break;
                }
            }else {
                NSError *e = [self buildErrorWithCode:kVCCErrorCodeUndefined
                                          andErrorMsg:@"undefined error occoured, parse network data error"];
                [self invokeBlockOnMainThreadWithSuccess:NO weather:nil andError:e];
            }
        }else {
            NSError *e = [self buildErrorWithCode:kVCCErrorCodeUndefined
                                      andErrorMsg:@"undefined error occoured, parse network data error"];
            [self invokeBlockOnMainThreadWithSuccess:NO weather:nil andError:e];
        }
    }];
    [task resume];
}

- (NSError *)buildErrorWithCode:(NSInteger)code andErrorMsg:(NSString *)msg {
    NSString *domain = @"com.Vungle.VungleCC.ErrorDomain";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : msg };
    NSError *error = [NSError errorWithDomain:domain
                                         code:code
                                     userInfo:userInfo];
    return error;
}

- (void)invokeBlockOnMainThreadWithSuccess:(BOOL)success
                                   weather:(VCCWeather *)weather
                                  andError:(NSError *)error {
    vcc_dispatch_main_async_safe(^{
        if (self.completionHandler) self.completionHandler(success, weather, error);
    });
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count > 0) {
        CLLocation *last = locations.lastObject;
        [self getWeatherWithCLLocationLon:last.coordinate.longitude
                                   andLat:last.coordinate.latitude];
        [self.locManager stopUpdatingLocation];
        self.locManager = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

@end
