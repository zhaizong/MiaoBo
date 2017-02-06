//
//  PBCNewestManager.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCNewestManager.h"

#import "PBCDirector.h"

#import "PBCNewest.h"
#import "PBCNewest_CoreAddition.h"

#import "PBCHTTPRequest.h"

static NSString *urlString = @"http://live.9158.com/Room/GetNewRoomOnline?page=%lu";

@implementation PBCNewestManager

#pragma mark - Lifecycle

+ (instancetype)defaultManager {
  return [PBCDirector defaultDirector].newestManager;
}

#pragma mark - HTTP

- (void)getNewestByPage:(NSUInteger)page success:(void (^)(NSArray<PBCNewest *> * _Nonnull))successBlock failure:(void (^)(NSError * _Nonnull))failureBlock {
  [PBCHTTPRequest get:[NSString stringWithFormat:urlString, page] params:nil success:^(id  _Nullable responseObject) {
    if (successBlock) {
      NSMutableArray *results = [NSMutableArray array];
      NSDictionary *data = responseObject[@"data"];
      NSArray *lists = data[@"list"];
      for (NSDictionary *dict in lists) {
        PBCNewest *newest = [[PBCNewest alloc] init];
        newest.flv = dict[@"flv"];
        newest.nickname = dict[@"nickname"];
        newest.photo = dict[@"photo"];
        newest.position = dict[@"position"];
        newest.useridx = dict[@"useridx"];
        newest.newStar = [dict[@"new"] unsignedIntegerValue];
        newest.msg = responseObject[@"msg"];
        [results addObject:[PBCNewest newestWithCoreNewest:newest]];
      }
      successBlock([results copy]);
    }
  } failure:^(NSError * _Nonnull error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
