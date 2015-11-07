//
//  ExchangesClient.m
//  Gogobit
//
//  Created by Wilson H. on 11/8/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import "ExchangesClient.h"

NSString * const MAICOIN_USD_API= @"https://api.maicoin.com/v1/prices/us";
NSString * const MAICOIN_TWD_API= @"https://api.maicoin.com/v1/prices/twd";
const NSInteger GLOBAL_API_TIMEDOUT = 60;

@implementation ExchangesClient

+ (instancetype)sharedClient {
    static ExchangesClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ExchangesClient alloc] init];
        //This is for testing request timedout
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        [_sharedClient setRequestSerializer:[AFJSONResponseSerializer serializer]];
        [_sharedClient setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [[_sharedClient requestSerializer] setTimeoutInterval:GLOBAL_API_TIMEDOUT];
    });

    return _sharedClient;
}

- (void)getMaicoinUSDPriceWithSender:(id<GogobitHttpProtocol>)sender {
    [self GET:MAICOIN_USD_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if ([sender respondsToSelector:@selector(appDidGetMaicoinTWDWithData:)]) {
            [sender appDidGetMaicoinTWDWithData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        NSInteger code = [operation.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(appGetMaicoinTWDDidFailWithCode:andResponse:)]) {
            [sender appGetMaicoinTWDDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

- (void)getMaicoinTWDPriceWithSender:(id<GogobitHttpProtocol>)sender {
    [self GET:MAICOIN_USD_API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        if ([sender respondsToSelector:@selector(appDidGetMaicoinTWDWithData:)]) {
            [sender appDidGetMaicoinTWDWithData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        NSInteger code = [operation.response statusCode];
        NSString *errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        if ([sender respondsToSelector:@selector(appGetMaicoinUSDDidFailWithCode:andResponse:)]) {
            [sender appGetMaicoinUSDDidFailWithCode:code andResponse:errorResponse];
        }
    }];
}

@end
