//
//  PBCLiveHotManager.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/26.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCHotManager.h"

#import "PBCDirector.h"

#import "PBCHot.h"
#import "PBCHot_CoreAddition.h"

#import "PBCHTTPRequest.h"

static NSString *urlString = @"https://live.9158.com/Fans/GetHotLive?page=%lu";

@implementation PBCHotManager

#pragma mark - Lifecycle

+ (instancetype)defaultManager {
  return [PBCDirector defaultDirector].hotManager;
}

#pragma mark - HTTP

- (void)getHotByPage:(NSUInteger)page success:(void (^)(NSArray<PBCHot *> * _Nonnull))successBlock failure:(void (^)(NSError * _Nonnull))failureBlock {
  [PBCHTTPRequest get:[NSString stringWithFormat:urlString, page] params:nil success:^(id  _Nullable responseObject) {
    if (successBlock) {
      NSMutableArray *hots = [NSMutableArray array];
      NSDictionary *data = responseObject[@"data"];
      NSArray *lists = data[@"list"];
      for (NSDictionary *dict in lists) {
        PBCHot *hot = [[PBCHot alloc] init];
        hot.bigpic = dict[@"bigpic"];
        hot.smallpic = dict[@"smallpic"];
        hot.flv = dict[@"flv"];
        hot.gps = dict[@"pgs"];
        hot.myname = dict[@"myname"];
        hot.starlevel = [dict[@"starlevel"] unsignedIntegerValue];
        hot.allnum = [dict[@"allnum"] unsignedIntegerValue];
        [hots addObject:[PBCHot hotWithCoreHot:hot]];
      }
      successBlock([hots copy]);
    }
  } failure:^(NSError * _Nonnull error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
