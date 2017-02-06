//
//  PBCHTTPRequest.h
//  broadcastcore
//
//  Created by Crazy on 2017/1/26.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface PBCHTTPRequest : NSObject

///-----------------------------------------
/// @name HTTP
///-----------------------------------------

+ (void)get:(NSString *)urlString params:(nullable id)params success:(void (^)(id _Nullable responseObject))successBlock failure:(void (^)(NSError *error))failureBlock;

+ (void)cancel;

@end
NS_ASSUME_NONNULL_END
