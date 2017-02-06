//
//  PBCLiveHot.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/26.
//  Copyright © 2017年 Crazy. All rights reserved.
//
#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "PBCHot.h"
#import "PBCHot_CoreAddition.h"

@implementation PBCHot

@synthesize bigpic = _bigpic;
@synthesize smallpic = _smallpic;
@synthesize flv = _flv;
@synthesize gps = _gps;
@synthesize myname = _myname;
@synthesize starlevel = _starlevel;
@synthesize allnum = _allnum;

#pragma mark - Property

- (NSString *)bigpic {
  return _bigpic;
}

- (void)setBigpic:(NSString *)bigpic {
  _bigpic = bigpic;
}

- (NSString *)smallpic {
  return _smallpic;
}

- (void)setSmallpic:(NSString *)smallpic {
  _smallpic = smallpic;
}

- (NSString *)flv {
  return _flv;
}

- (void)setFlv:(NSString *)flv {
  _flv = flv;
}

- (NSString *)gps {
  return _gps;
}

- (void)setGps:(NSString *)gps {
  _gps = gps;
}

- (NSString *)myname {
  return _myname;
}

- (void)setMyname:(NSString *)myname {
  _myname = myname;
}

- (NSUInteger)starlevel {
  return _starlevel;
}

- (void)setStarlevel:(NSUInteger)starlevel {
  _starlevel = starlevel;
}

- (NSUInteger)allnum {
  return _allnum;
}

- (void)setAllnum:(NSUInteger)allnum {
  _allnum = allnum;
}

#pragma mark - Core Addition

+ (instancetype)hotWithCoreHot:(PBCHot *)hot {
  return hot;
}

@end
