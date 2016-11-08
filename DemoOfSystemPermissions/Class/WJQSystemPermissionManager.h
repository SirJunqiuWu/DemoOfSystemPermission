//
//  WJQSystemPermissionManager.h
//  DemoOfSystemPermissions
//
//  Created by 吴 吴 on 16/11/8.
//  Copyright © 2016年 JackWu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 权限认证状态
 */
typedef NS_ENUM(NSInteger,AuthStatus)
{
    //未决定
    NotDetermined = 0,
    //允许
    Allowed,
    //拒绝
    Denied,
    //未知错误(设备不支持等)
    UnknowError
};

@interface WJQSystemPermissionManager : NSObject


/**
 单例

 @return <#return value description#>
 */
+(WJQSystemPermissionManager *)sharedManager;


/**
 检测语音是否可用

 @param status 当前状态描述
 */
- (void)checkAudioAuthorizationStatusWithCallback:(void(^)(AuthStatus status))callback;

@end
