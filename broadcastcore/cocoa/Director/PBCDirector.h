//
//  PBCDirector.h
//  broadcastcore
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@class PBCLiveBannerManager;
@class PBCHotManager;
@class PBCNewestManager;
/**
 *  这个文件是手写的，我将 Director 当作是操作这台设备的用户，所有与其相关的操作如 SignIn, Logout 等都在该类中，
 *  该类采用单例模式设计，在初始化该类后，各个 ObjectManager 都会被初始化成功并且被 Director 所拥有 -- 在 Director
 *  销毁的时候销毁所有的 Manager。
 */

/**
 *  核心控制器，包含了所有的 ObjectManager.
 */
NS_ASSUME_NONNULL_BEGIN
@interface PBCDirector : NSObject

/**
 *  初始化 director, 用于登录、注册等访问具体数据前的操作
 *
 *  param config Web 端访问设置 如果有
 *
 *  @return 初始化的 director instance
 */
- (instancetype)initAsStrangerWithConfiguration;

/**
 *  singleton director
 *
 *  @return singleton director
 */
+ (nullable instancetype)defaultDirector;

/**
 *  设置为 nil 则销毁 |defaultDirector|.
 */
+ (void)resetDefaultDirector:(nullable PBCDirector *)director;

- (BOOL)initOrDie;

@end

@interface PBCDirector ()

@property (nonatomic, strong, readonly) PBCLiveBannerManager *bannerManager;
@property (nonatomic, strong, readonly) PBCHotManager *hotManager;
@property (nonatomic, strong, readonly) PBCNewestManager *newestManager;

@property (nonatomic, strong, readonly) FMDatabase *main_db_;

- (void)resetManagers;

@end
NS_ASSUME_NONNULL_END
