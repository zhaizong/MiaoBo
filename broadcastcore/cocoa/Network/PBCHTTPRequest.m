//
//  PBCHTTPRequest.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/26.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCHTTPRequest.h"
#import "PBCHTTPSessionManager.h"

@implementation PBCHTTPRequest

+ (void)get:(NSString *)urlString params:(id)params success:(void (^)(id _Nullable))successBlock failure:(void (^)(NSError * _Nonnull))failureBlock {
//  获得请求管理者
  PBCHTTPSessionManager *manager = [PBCHTTPSessionManager manager];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//  发送GET请求
  [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (successBlock) {
      successBlock(responseObject);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (failureBlock) {
      failureBlock(error);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }];
}

+ (void)cancel {
  [[PBCHTTPSessionManager manager].operationQueue cancelAllOperations];
}

@end
