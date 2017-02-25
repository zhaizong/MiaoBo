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

#import "FMDB.h"

#import "PBCLiveBannerManager.h"

#import "PBCDirector.h"
#import "PBCObjectManager.h"

#import "PBCLiveBanner.h"
#import "PBCLiveBanner_CoreAddition.h"

#import "PBCHTTPRequest.h"

static NSString *urlString = @"https://live.9158.com/Living/GetAD";

@interface PBCLiveBannerManager () {
  @private
  FMResultSet *banners_rs_;
}

@end

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

- (BOOL)initOrDie {
  BOOL success = YES;
  
  do {
    banners_rs_ = [[PBCObjectManager mainDatabaseHandler] executeQuery:@"select * from banners"];
    if (![banners_rs_ next]) {
      success = [[PBCObjectManager mainDatabaseHandler] executeUpdate:@"create table banners(imageUrl text)"];
      assert(success);
    }
  } while (0);
  
  return success;
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
      [self saveBannerToCache:[banners copy]];
      successBlock([banners copy]);
    }
  } failure:^(NSError * _Nonnull error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

#pragma mark - Persistent store

- (nullable NSArray<PBCLiveBanner *> *)fetchBannerFromCache {
  NSMutableArray *results = [NSMutableArray array];
  
  if ([[PBCObjectManager mainDatabaseHandler] open]) {
    banners_rs_ = [[PBCObjectManager mainDatabaseHandler] executeQuery:@"select imageUrl from banners"];
    while ([banners_rs_ next]) {
      [results addObject:[self bannerFromRecord:banners_rs_]];
    }
  }
  
  return [results copy];
}

- (void)saveBannerToCache:(NSArray<PBCLiveBanner *> *)banners {
  [PBCObjectManager beginTransaction];
  
  for (PBCLiveBanner *banner in banners) {
    [self unsafeSaveUserToCache:banner];
  }
  
  [PBCObjectManager commitTransaction];
  
  // 关闭数据库
  [[PBCObjectManager mainDatabaseHandler] close];
}

// Utils --------------------------------------------------------

- (void)unsafeSaveUserToCache:(PBCLiveBanner *)banner {
  [[PBCObjectManager mainDatabaseHandler] executeUpdate:@"insert into banners (imageUrl) values (?)", banner.imageUrl];
}

- (PBCLiveBanner *)bannerFromRecord:(FMResultSet *)rs {
  PBCLiveBanner *banner = [[PBCLiveBanner alloc] init];
  banner.imageUrl = [rs stringForColumn:@"imageUrl"];
  return banner;
}

@end
