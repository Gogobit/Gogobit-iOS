//
//  GogobitHttpClient.h
//  Gogobit
//
//  Created by Wilson H. on 4/19/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "GogobitHttpProtocol.h"

typedef NS_ENUM(NSInteger, ExchangeCode) {
    Coinbase = 0,
    Bitstamp = 1,
    Maicoin = 2,
    Okcoin = 3,
    Bitfinex = 4,
    Bitoex = 5,
};

@interface GogobitHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (NSURLSessionDataTask *)getExchangePriceWithName:(NSInteger)code andSender:(id<GogobitHttpProtocol>)sender;
- (void)checkNetworkReachableWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getPostsWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getYesterDayPriceWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getNewsSourceListWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getBitoexBrokerPriceWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getMaicoinBrokerPriceWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)getDeviceAlarmListWithSender:(id<GogobitHttpProtocol>)sender;
- (NSURLSessionDataTask *)setAlarmWithSender:(id<GogobitHttpProtocol>)sender andAlarmObject:(NSDictionary *)alarmObject;
- (NSURLSessionDataTask *)deleteAlarmWithSender:(id<GogobitHttpProtocol>)sender andAlarmObject:(NSDictionary *)alarmObject;

@end