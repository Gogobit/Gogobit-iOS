//
//  ExchangesClient.h
//  Gogobit
//
//  Created by Wilson H. on 11/8/15.
//  Copyright © 2015 Wilson H. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "GogobitHttpProtocol.h"

@interface ExchangesClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;
- (void)getMaicoinUSDPriceWithSender:(id<GogobitHttpProtocol>)sender;
- (void)getMaicoinTWDPriceWithSender:(id<GogobitHttpProtocol>)sender;

@end
