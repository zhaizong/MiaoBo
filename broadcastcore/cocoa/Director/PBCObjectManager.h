//
//  PBCObjectManager.h
//  broadcastcore
//
//  Created by Crazy on 2017/2/19.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN
@interface PBCObjectManager : NSObject

+ (FMDatabase *)mainDatabaseHandler;

+ (void)beginTransaction;

+ (void)commitTransaction;

@end
NS_ASSUME_NONNULL_END
