//
//  PBCDirector.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "FMDB.h"

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
  
  FMDatabase *_main_db_;
}

@end

@implementation PBCDirector

#pragma mark - Lifecycle

- (instancetype)initAsStrangerWithConfiguration {
  if (self == [super init]) {
    
  }
  return self;
}

- (BOOL)initOrDie {
  // Create folder if not exists
  NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
  NSString *folder_path = [path stringByAppendingString:@"/uid/"];
  NSString *main_db_path = [folder_path stringByAppendingString:@"MiaoBo.db"];
  NSLog(@"database path is %@", main_db_path);
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:folder_path]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:folder_path withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  BOOL success = YES;
  
  do {
    // Open SQLite
    _main_db_ = [FMDatabase databaseWithPath:main_db_path];
    @try {
      success = [_main_db_ open];
    } @catch (NSException *exception) {
      NSLog(@"Director cannot open database: %@", exception.reason);
      return NO;
    }
    
    if (!success) {
      break;
    }
    
    // Init tables
    // Banner manager
    success = [_bannerManager initOrDie];
    if (!success) {
      break;
    }
    
    // Init WebApi
    
  } while (0);
  
  [_main_db_ close];
  return success;
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
