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

- (void)appDidGetMaicoinTWDWithData:(NSDictionary *)data;
- (void)appGetMaicoinTWDDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;
- (void)appDidGetMaicoinUSDWithData:(NSDictionary *)data;
- (void)appGetMaicoinUSDDidFailWithCode:(NSInteger)code andResponse:(NSString *)errorResponse;

@end