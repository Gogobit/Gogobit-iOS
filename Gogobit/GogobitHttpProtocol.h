//
//  GogobitHttpProtocol.h
//  Gogobit
//
//  Created by Wilson H. on 11/8/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GogobitHttpProtocol <NSObject>

@optional

- (void)boardDidGetExchangePriceWithName:(NSInteger)name andData:(id)data;
- (void)boardGetExchangePriceDidFailWithCode:(NSInteger)code name:(NSInteger)name andResponse:(NSString *)errorResponse;
- (void)appCheckNetworkDidFailWithStatus:(NSUInteger)status;
- (void)flowDidGetPostsWithData:(id)data;
- (void)flowGetPostsDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
- (void)boardDidGetYesterdayPriceWithData:(id)data;
- (void)boardGetYesterdayPriceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
- (void)flowDidGetNewsSourceListWithData:(id)data;
- (void)flowGetSourceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
- (void)flowDidGetBitoexBrokerPriceWithData:(id)data;
- (void)flowGetBitoexBrokerPriceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
- (void)flowDidGetMaicoinBrokerPriceWithData:(id)data;
- (void)flowGetMaicoinBrokerPriceDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;

@end