//
//  Whitelist.m
//  PacketTunnel
//
//  Created by paul on 2023/5/18.
//  Copyright © 2023 TouchingApp. All rights reserved.
//

#import "Whitelist.h"

@implementation Whitelist

static NSDate *_lastCheck;
static dispatch_source_t timer;

+ (NSDate *)lastCheck {
    return _lastCheck;
}

+ (void)setLastCheck:(NSDate *)lastCheck {
    _lastCheck = lastCheck;
}

+ (void)startWhitelist {
    NSLog(@"[Whitelist] Timer will start later");
    
    // create and config gcd timer
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t interval = 10 * NSEC_PER_SEC; // 10s
    dispatch_source_set_timer(timer, startTime, interval, 0);
    
    // set timer loop function
    dispatch_source_set_event_handler(timer, ^{
        [self loop];
    });
    
    // start timer
    dispatch_resume(timer);
    
    NSLog(@"[Whitelist] Timer has been started");
}

+ (void)loop {
    NSLog(@"[Whitelist] now is looping");
    NSString *profileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileName"];
    NSString *profileHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileHost"];
    NSLog(@"[Whitelist] profile info: %@ %@", profileName, profileHost);

    [self getPublicIPWithCompletionHandler:^(NSError * _Nullable error, NSString * _Nullable publicIP) {
        if (error) {
            NSLog(@"[Whitelist] Failed to get public IP: %@", error.localizedDescription);
            return;
        }
        
        NSLog(@"[Whitelist] Public IP: %@", publicIP);
    }];
}


+ (void)stopWhitelist{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

+ (void)getPublicIPWithCompletionHandler:(void (^)(NSError * _Nullable, NSString * _Nullable))completionHandler {
    NSString *urlString = @"http://checkip.amazonaws.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.connectionProxyDictionary = @{};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(error, nil);
            return;
        }
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
            completionHandler(error, nil);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            error = [NSError errorWithDomain:NSURLErrorDomain code:httpResponse.statusCode userInfo:nil];
            completionHandler(error, nil);
            return;
        }
        NSString *publicIP = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        publicIP = [publicIP stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        completionHandler(nil, publicIP);
    }];
    [task resume];
}

@end
