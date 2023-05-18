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
static NSTimer *_timer;

+ (NSDate *)lastCheck {
    return _lastCheck;
}

+ (void)setLastCheck:(NSDate *)lastCheck {
    _lastCheck = lastCheck;
}

+ (NSTimer *)timer {
    return _timer;
}

+ (void)setTimer:(NSTimer *)timer {
    if (_timer != timer) {
        [_timer invalidate];
        _timer = timer;
    }
}

+ (void)startWhitelist {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(loop) userInfo:nil repeats:YES];
}

+ (void)loop {
    NSString *profileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileName"];
    NSString *profileHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileHost"];
    NSLog(@"profile info: %@ %@", profileName, profileHost);

    
    [self getPublicIPWithCompletionHandler:^(NSError * _Nullable error, NSString * _Nullable publicIP) {
        if (error) {
            NSLog(@"Failed to get public IP: %@", error.localizedDescription);
            return;
        }
        
        NSLog(@"Public IP: %@", publicIP);
    }];
}


+ (void)stopWhitelist{
    self.timer = nil;
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
