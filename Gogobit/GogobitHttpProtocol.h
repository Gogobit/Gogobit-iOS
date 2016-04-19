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

//- (void)boardDidGetMaicoinUsdWithData:(NSDictionary *)data;
//- (void)boardGetMaicoinUsdDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
//
//- (void)boardDidGetBitfinexUsdWithData:(NSDictionary *)data;
//- (void)boardGetBitfinexUsdDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;

- (void)boardDidGetExchangePriceWithName:(NSInteger)name andData:(id)data;
- (void)boardGetExchangePriceDidFailWithCode:(NSInteger)code name:(NSInteger)name andResponse:(NSString *)errorResponse;
@end