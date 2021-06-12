//
//  ViewController.m
//  VungleDemo
//
//  Created by Chao Zhang on 2021/6/12.
//

#import "ViewController.h"
#import <VCCWeatherFetcher.h>

@interface ViewController ()

@property (nonatomic, strong) VCCWeatherFetcher *fetcher;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetcher = [[VCCWeatherFetcher alloc] init];
    self.fetcher.tempUnit = VCCWFTemperatureUnitCelsius;
    self.fetcher.zipCode = @"94040";
    self.fetcher.countryCode = @"usdddd";
    [self.fetcher getWeatherWithCompletionHandler:^(BOOL success, VCCWeather * _Nullable weather, NSError * _Nullable error) {
        if (error) {
            return;
        }
        NSLog(@"abc");
    }];
}


@end
