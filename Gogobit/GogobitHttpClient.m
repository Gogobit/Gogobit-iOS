//
//  GogobitHttpClient.m
//  Gogobit
//
//  Created by Wilson H. on 4/19/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "GogobitHttpClient.h"
#import "AFHTTPSessionManager+AutoRetry.h"

const NSInteger GLOBAL_API_TIMEDOUT = 60;
const NSInteger GLOBAL_RETRY_COUNT = 3;
NSString *const MAICOIN_USD_PRICE_API = @"https://api.maicoin.com/v1/prices/usd";
NSString *const BITFINEX_USD_PRICE_API = @"https://api.bitfinex.com/v1/pubticker/BTCUSD";
NSString *const COINBASE_USD_PRICE_API = @"https://api.coinbase.com/v2/prices/spot";
NSString *const BITSTAMP_USD_PRICE_API = @"https://www.bitstamp.net/api/ticker/";
NSString *const OKCOIN_USD_PRICE_API = @"https://www.okcoin.com/api/ticker.do?ok=1";
NSString *const BITOEX_TWD_PRICE_API = @"https://www.bitoex.com/api/v1/get_rate";

@implementation GogobitHttpClient

+ (instancetype)sharedClient {
    static GogobitHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GogobitHttpClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer.acceptableContentTypes = nil;
        [[_sharedClient requestSerializer] setTimeoutInterval:GLOBAL_API_TIMEDOUT];
    });

    return _sharedClient;
}

- (NSURLSessionDataTask *)doGET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id respo))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    return [self GET:URLString parameters:parameters success:success failure:failure autoRetry:GLOBAL_RETRY_COUNT];
}

- (NSURLSessionDataTask *)doPOST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    return [self POST:URLString parameters:parameters success:success failure:failure autoRetry:GLOBAL_RETRY_COUNT];
}

- (NSURLSessionDataTask *)getExchangePriceWithName:(NSInteger)name andSender:(id<GogobitHttpProtocol>)sender {
    NSString *url = [NSString stringWithString:[self getUrlWithName:name]];
    return [self doGET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(boardDidGetExchangePriceWithName:andData:)]) {
            [sender boardDidGetExchangePriceWithName:name andData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(boardGetExchangePriceDidFailWithCode:name:andResponse:)]) {
            [sender boardGetExchangePriceDidFailWithCode:code name:(NSInteger)name andResponse:errorResponse];
        }
    }];
}

- (void)checkNetworkReachableWithSender:(id<GogobitHttpProtocol>)sender {
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ([sender respondsToSelector:@selector(appCheckNetworkDidFailWithStatus:)]) {
            [sender appCheckNetworkDidFailWithStatus:status];
        }
    }];
    [self.reachabilityManager startMonitoring];
}


- (NSString *)getUrlWithName:(NSInteger)name {
    NSString *url = [[NSString alloc] init];
    switch (name) {
        case Coinbase:
            url = [NSString stringWithString:COINBASE_USD_PRICE_API];
            break;
        case Bitstamp:
            url = [NSString stringWithString:BITSTAMP_USD_PRICE_API];
            break;
        case Bitfinex:
            url = [NSString stringWithString:BITFINEX_USD_PRICE_API];
            break;
        case Bitoex:
            url = [NSString stringWithString:BITOEX_TWD_PRICE_API];
            break;
        case Maicoin:
            url = [NSString stringWithString:MAICOIN_USD_PRICE_API];
            break;
        case Okcoin:
            url = [NSString stringWithString:OKCOIN_USD_PRICE_API];
            break;
        default:
            break;
    }
    return url;
}

@end
