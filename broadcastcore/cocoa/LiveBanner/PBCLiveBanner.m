//
//  PBCLiveBanner.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//
#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "PBCLiveBanner.h"
#import "PBCLiveBanner_CoreAddition.h"

@implementation PBCLiveBanner

@synthesize imageUrl = _imageUrl;

#pragma mark - Property

- (NSString *)imageUrl {
  return _imageUrl;
}

- (void)setImageUrl:(NSString *)imageUrl {
  _imageUrl = imageUrl;
}

#pragma mark - Core Addition

+ (instancetype)liveBannerWithCoreLiveBanner:(PBCLiveBanner *)liveBanner {
//  PBCLiveBanner *live = [[PBCLiveBanner alloc] init];
//  live->_coreHandle = coreLive.Clone();
  return liveBanner;
}

@end
