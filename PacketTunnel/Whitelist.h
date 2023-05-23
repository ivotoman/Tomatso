//
//  Whitelist.h
//  Potatso
//
//  Created by paul on 2023/5/18.
//  Copyright © 2023 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import "PotatsoBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface Whitelist : NSObject

@property (class, nonatomic, strong) NSDate *lastCheck;

+ (void)startWhitelist;
+ (void)stopWhitelist;
+ (void)getPublicIPWithCompletionHandler:(void (^)(NSError * _Nullable error, NSString * _Nullable publicIP))completionHandler;
+ (void)loop;

@end

NS_ASSUME_NONNULL_END
