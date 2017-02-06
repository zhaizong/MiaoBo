//
//  PBKForceRotationScreen.m
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBKForceRotationScreen.h"

@implementation PBKForceRotationScreen

+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
  
  // arc下 setOrientation: 私有方法强制横屏
  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    
    //    从2开始是因为0 1 两个参数已经被selector和target占用
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
  }
  if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
    // TODO: - 设置横屏
  } else if (orientation == UIInterfaceOrientationPortrait) {
    //TODO: - 设置竖屏
  }
  
}

+ (BOOL)isOrientationLandscape {
  
  if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return YES;
  } else {
    return NO;
  }
}

@end
