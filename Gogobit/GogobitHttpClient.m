//
//  GogobitHttpClient.m
//  Gogobit
//
//  Created by Wilson H. on 4/19/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "GogobitHttpClient.h"
#import "AFHTTPSessionManager+AutoRetry.h"

const NSInteger GLOBAL_API_TIMEDOUT = 15;
const NSInteger GLOBAL_RETRY_COUNT = 3;
NSString *const MAICOIN_USD_PRICE_API = @"https://api.maicoin.com/v1/prices/usd";
NSString *const MAICOIN_TWD_PRICE_API = @"https://api.maicoin.com/v1/prices/twd";
NSString *const BITOEX_TWD_PRICE_API = @"https://www.bitoex.com/api/v1/get_rate";
NSString *const BITFINEX_USD_PRICE_API = @"https://api.bitfinex.com/v1/pubticker/BTCUSD";
NSString *const COINBASE_USD_PRICE_API = @"https://api.coinbase.com/v2/prices/spot";
NSString *const BITSTAMP_USD_PRICE_API = @"https://www.bitstamp.net/api/ticker/";
NSString *const OKCOIN_USD_PRICE_API = @"https://www.okcoin.com/api/ticker.do?ok=1";
NSString *const GOGOBIT_NEWS_API = @"http://www.gogobit.com/api/v0/news/query?queryCode=";
NSString *const YESTERDAY_USD_PRICE_API = @"https://api.coinbase.com/v2/prices/spot?date=";
NSString *const GOGOBIT_NEWS_SOURCE_LIST = @"http://www.gogobit.com/api/v0/news/sources";



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
            [sender boardGetExchangePriceDidFailWithCode:code name:name andResponse:errorResponse];
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

- (NSURLSessionDataTask *)getPostsWithSender:(id<GogobitHttpProtocol>)sender {
    NSUInteger codeLength = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceNum"] integerValue];
    NSString *sourceQueryCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sourceQueryCode"] substringWithRange:NSMakeRange(0, codeLength)];

    return [self doGET:[NSString stringWithFormat:@"%@%@", GOGOBIT_NEWS_API, sourceQueryCode] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(flowDidGetPostsWithData:)]) {
            [sender flowDidGetPostsWithData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(flowGetPostsDidFailWithCode:andResponse:)]) {
            [sender flowGetPostsDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

- (NSURLSessionDataTask *)getYesterDayPriceWithSender:(id<GogobitHttpProtocol>)sender {
    NSString *url = [NSString stringWithFormat:@"%@%@", YESTERDAY_USD_PRICE_API, [self getYesterdayString]];
    return [self doGET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(boardDidGetYesterdayPriceWithData:)]) {
            [sender boardDidGetYesterdayPriceWithData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(boardGetYesterdayPriceDidFailWithCode:andResponse:)]) {
            [sender boardGetYesterdayPriceDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

- (NSURLSessionDataTask *)getNewsSourceListWithSender:(id<GogobitHttpProtocol>)sender {
    return [self doGET:GOGOBIT_NEWS_SOURCE_LIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(flowDidGetNewsSourceListWithData:)]) {
            [sender flowDidGetNewsSourceListWithData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(flowGetSourceDidFailWithCode:andResponse:)]) {
            [sender flowGetSourceDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

- (NSURLSessionDataTask *)getBitoexBrokerPriceWithSender:(id<GogobitHttpProtocol>)sender {
    return [self doGET:BITOEX_TWD_PRICE_API parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(flowDidGetBitoexBrokerPriceWithData:)]) {
            [sender flowDidGetBitoexBrokerPriceWithData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(flowGetBitoexBrokerPriceDidFailWithCode:andResponse:)]) {
            [sender flowGetBitoexBrokerPriceDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

- (NSURLSessionDataTask *)getMaicoinBrokerPriceWithSender:(id<GogobitHttpProtocol>)sender {
    return [self doGET:MAICOIN_TWD_PRICE_API parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([sender respondsToSelector:@selector(flowDidGetMaicoinBrokerPriceWithData:)]) {
            [sender flowDidGetMaicoinBrokerPriceWithData:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSInteger code = [(NSHTTPURLResponse *)task.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(flowGetMaicoinBrokerPriceDidFailWithCode:andResponse:)]) {
            [sender flowGetMaicoinBrokerPriceDidFailWithCode:code andResponse:errorResponse];
        }
    }];
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

- (NSString *)getYesterdayString {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                     fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *yesterdayString = [formatter stringFromDate:yesterday];

    return yesterdayString;
}

@end
