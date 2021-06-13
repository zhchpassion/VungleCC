//
//  VungleCCTests.m
//  VungleCCTests
//
//  Created by Chao Zhang on 2021/6/13.
//

#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>
#import "VCCWeatherFetcher.h"




@interface VungleCCTests : XCTestCase

@property (nonatomic, assign) NSTimeInterval waitTime;

@end

@implementation VungleCCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.waitTime = 40.0;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

+ (CLAuthorizationStatus)swizzledAuthorizationStatus {
    return kCLAuthorizationStatusDenied;
}

- (void)testNoGeoLocationAuthorizationError {
    // mock: hook system [CLLocationManager authorizationStatus], simulate it returns kCLAuthorizationStatusDenied
    Class targetClass = NSClassFromString(@"CLLocationManager");
    SEL oriSEL = @selector(authorizationStatus);
    Method oriMethod = class_getClassMethod(targetClass, oriSEL);
    
    SEL cusSEL = @selector(swizzledAuthorizationStatus);
    Method cusMethod = class_getClassMethod([self class], cusSEL);
    
    BOOL addSucc = class_addMethod(targetClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        class_replaceMethod([self class], cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else {
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"error thrown"];
    VCCWeatherFetcher *obj = [[VCCWeatherFetcher alloc] init];
    obj.tempUnit = VCCWFTemperatureUnitCelsius;
    [obj getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        XCTAssertEqual(error.code, kVCCErrorCodeNoLocationAuthorization);
        XCTAssertNil(weather);
        XCTAssertFalse(success);
        [expectation fulfill];
    }];
    method_exchangeImplementations(cusMethod, oriMethod);
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
    
}

- (void)testInvalidZipCodeError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"error thrown"];
    VCCWeatherFetcher *obj = [[VCCWeatherFetcher alloc] init];
    obj.tempUnit = VCCWFTemperatureUnitCelsius;
    obj.zipCode = @"12345";
    obj.countryCode = @"abcede";
    [obj getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        XCTAssertEqual(error.code, kVCCErrorCodeInvalidZipCode);
        XCTAssertNil(weather);
        XCTAssertFalse(success);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
}

- (void)testZipCodeSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"data fetched"];
    VCCWeatherFetcher *obj = [[VCCWeatherFetcher alloc] init];
    obj.tempUnit = VCCWFTemperatureUnitKelvin;
    obj.zipCode = @"94040";
    obj.countryCode = @"us";
    [obj getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        XCTAssertTrue(success);
        XCTAssertNotNil(weather);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
}

- (void)testGeoLocationSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"data fetched"];
    VCCWeatherFetcher *obj = [[VCCWeatherFetcher alloc] init];
    obj.tempUnit = VCCWFTemperatureUnitCelsius;
    // mock: simulate CLLocationManager update location after a while
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        double lat = arc4random() % 90;
        double lon = arc4random() % 180;
        BOOL isNegtive = (arc4random() % 2) == 1;
        if (isNegtive) lat *= -1;
        isNegtive = (arc4random() % 2) == 1;
        if (isNegtive) lon *= -1;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [obj performSelector:@selector(locationManager:didUpdateLocations:) withObject:[CLLocationManager new] withObject:@[location]];
    });
    [obj getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        XCTAssertTrue(success);
        XCTAssertNotNil(weather);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.waitTime handler:nil];
}


@end
