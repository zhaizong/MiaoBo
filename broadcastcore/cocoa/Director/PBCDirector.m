//
//  PBCDirector.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCDirector.h"
#import "PBCLiveBannerManager.h"
#import "PBCHotManager.h"
#import "PBCNewestManager.h"

static PBCDirector *_sharedDirector;

@interface PBCDirector () {
  @private
  PBCLiveBannerManager *_bannerManager;
  PBCHotManager *_hotManager;
  PBCNewestManager *_newestManager;
}

@end

@implementation PBCDirector

#pragma mark - Lifecycle

- (instancetype)initAsStrangerWithConfiguration {
  if (self == [super init]) {
    
  }
  return self;
}

- (void)dealloc {
  _bannerManager = nil;
  _hotManager = nil;
  _newestManager = nil;
}

+ (nullable instancetype)defaultDirector {
  return _sharedDirector;
}

+ (void)resetDefaultDirector:(PBCDirector *)director {
  if (!director) {
    NSLog(@"Director::resetDefaultDirector director should not be nil, consider using lck_resetDefaultAsStranger");
    assert(false);
  }
  _sharedDirector = nil;
  _sharedDirector = director;
}

- (PBCLiveBannerManager *)bannerManager {
  return _bannerManager;
}

- (PBCHotManager *)hotManager {
  return _hotManager;
}

- (PBCNewestManager *)newestManager {
  return _newestManager;
}

#pragma mark - Managers

- (void)resetManagers {
  _bannerManager = [[PBCLiveBannerManager alloc] init];
  _hotManager = [[PBCHotManager alloc] init];
  _newestManager = [[PBCNewestManager alloc] init];
}

@end
