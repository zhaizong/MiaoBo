//
//  PBCHotManager.h
//  broadcastcore
//
//  Created by Crazy on 2017/1/26.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBCHot;

NS_ASSUME_NONNULL_BEGIN
@interface PBCHotManager : NSObject

///-----------------------------------------
/// @name Lifecycle
///-----------------------------------------

+ (instancetype)defaultManager;

///-----------------------------------------
/// @name HTTP
///-----------------------------------------

- (void)getHotByPage:(NSUInteger)page success:(void (^)(NSArray<PBCHot *> *hots))successBlock failure:(void (^)(NSError *error))failureBlock;

///-----------------------------------------
/// @name Persistent store
///-----------------------------------------

@end
NS_ASSUME_NONNULL_END
