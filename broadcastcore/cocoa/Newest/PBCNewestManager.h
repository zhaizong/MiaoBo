//
//  PBCNewestManager.h
//  broadcastcore
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBCNewest;

NS_ASSUME_NONNULL_BEGIN
@interface PBCNewestManager : NSObject

///-----------------------------------------
/// @name Lifecycle
///-----------------------------------------

+ (instancetype)defaultManager;

///-----------------------------------------
/// @name HTTP
///-----------------------------------------

- (void)getNewestByPage:(NSUInteger)page
                success:(void (^)(NSArray<PBCNewest *> *newests))successBlock
                failure:(void (^)(NSError *error))failureBlock;

///-----------------------------------------
/// @name Persistent store
///-----------------------------------------

@end
NS_ASSUME_NONNULL_END
