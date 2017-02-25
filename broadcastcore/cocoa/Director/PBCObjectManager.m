//
//  PBCObjectManager.m
//  broadcastcore
//
//  Created by Crazy on 2017/2/19.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCObjectManager.h"

#import "PBCDirector.h"

@implementation PBCObjectManager

// SQLite --------------------------------------------------------

+ (FMDatabase *)mainDatabaseHandler {
  assert([[PBCDirector defaultDirector] main_db_].open);
  return [[PBCDirector defaultDirector] main_db_];
}

+ (void)beginTransaction {
  [[[PBCDirector defaultDirector] main_db_] beginTransaction];
}

+ (void)commitTransaction {
  [[[PBCDirector defaultDirector] main_db_] commit];
}

@end
