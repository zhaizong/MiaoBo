//
//  PBCLiveBannerManager.h
//  broadcastcore
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBCLiveBanner;

NS_ASSUME_NONNULL_BEGIN
@interface PBCLiveBannerManager : NSObject

///-----------------------------------------
/// @name Lifecycle
///-----------------------------------------

+ (instancetype)defaultManager;

///-----------------------------------------
/// @name HTTP
///-----------------------------------------

- (void)getLiveBannerSuccess:(void (^)(NSArray<PBCLiveBanner *> *banners))successBlock failure:(void (^)(NSError *error))failureBlock;

///-----------------------------------------
/// @name Persistent store
///-----------------------------------------

//- (nullable PBCLiveBanner *)fetchBannerFromCacheByUid:(NSString *)uid;

@end
NS_ASSUME_NONNULL_END
