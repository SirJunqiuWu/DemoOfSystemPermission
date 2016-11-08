//
//  WJQSystemPermissionManager.m
//  DemoOfSystemPermissions
//
//  Created by 吴 吴 on 16/11/8.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import "WJQSystemPermissionManager.h"
#import <AVFoundation/AVFoundation.h>

static WJQSystemPermissionManager *selfManager = nil;
@implementation WJQSystemPermissionManager

+ (WJQSystemPermissionManager *)sharedManager {
    @synchronized (self) {
        static dispatch_once_t pred;
        dispatch_once(&pred,^{
            selfManager = [[self alloc]init];
        });
    }
    return selfManager;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)checkAudioAuthorizationStatusWithCallback:(void (^)(AuthStatus))callback {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        [audioSession requestRecordPermission:^(BOOL granted)
        {
            if (granted == YES)
            {
                callback(Allowed);
                return ;
            }
            else
            {
                callback(Denied);
                return ;
            }
        }];
    }
    else
    {
        callback(UnknowError);
        return ;
    }
}

@end
