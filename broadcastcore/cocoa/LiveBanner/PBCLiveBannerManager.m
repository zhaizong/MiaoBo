//
//  PBCLiveBannerManager.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//
#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "PBCLiveBannerManager.h"

#import "PBCDirector.h"

#import "PBCLiveBanner.h"
#import "PBCLiveBanner_CoreAddition.h"

#import "PBCHTTPRequest.h"

static NSString *urlString = @"https://live.9158.com/Living/GetAD";

@implementation PBCLiveBannerManager

#pragma mark - Lifecycle

- (instancetype)init {
  if (self == [super init]) {
    // TODO: - 在这里初始化 coreHandler
  }
  return self;
}

+ (instancetype)defaultManager {
  return [PBCDirector defaultDirector].bannerManager;
}

#pragma mark - HTTP

- (void)getLiveBannerSuccess:(void (^)(NSArray<PBCLiveBanner *> * _Nonnull))successBlock failure:(void (^)(NSError * _Nonnull))failureBlock {
  [PBCHTTPRequest get:urlString params:nil success:^(id  _Nullable responseObject) {
    if (successBlock) {
      NSMutableArray *banners = [NSMutableArray array];
      NSArray *datas = responseObject[@"data"];
      for (NSDictionary *dict in datas) {
        PBCLiveBanner *banner = [[PBCLiveBanner alloc] init];
        banner.imageUrl = [dict[@"imageUrl"] copy];
        [banners addObject:[PBCLiveBanner liveBannerWithCoreLiveBanner:banner]];
      }
      successBlock([banners copy]);
    }
  } failure:^(NSError * _Nonnull error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

#pragma mark - Persistent store

@end
