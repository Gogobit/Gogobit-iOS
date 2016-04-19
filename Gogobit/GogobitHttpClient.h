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

@end