//
//  PBCHTTPSessionManager.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCHTTPSessionManager.h"

@implementation PBCHTTPSessionManager

+ (instancetype)manager {
  
  PBCHTTPSessionManager *manager = [super manager];
  //  设置超时时间为10s
  manager.requestSerializer.timeoutInterval = 10;
  //  申明返回的结果是text/html类型
  //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
  
  return manager;
}

@end
