//
//  PBCNewest.m
//  broadcastcore
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

#import "PBCNewest.h"
#import "PBCNewest_CoreAddition.h"

@implementation PBCNewest

@synthesize flv = _flv;
@synthesize nickname = _nickname;
@synthesize photo = _photo;
@synthesize position = _position;
@synthesize useridx = _useridx;
@synthesize newStar = _newStar;
@synthesize msg = _msg;

#pragma mark - Property

- (NSString *)flv {
  return _flv;
}

- (void)setFlv:(NSString *)flv {
  _flv = flv;
}

- (NSString *)nickname {
  return _nickname;
}

- (void)setNickname:(NSString *)nickname {
  _nickname = nickname;
}

- (NSString *)photo {
  return _photo;
}

- (void)setPhoto:(NSString *)photo {
  _photo = photo;
}

- (NSString *)position {
  return _position;
}

- (void)setPosition:(NSString *)position {
  _position = position;
}

- (NSString *)useridx {
  return _useridx;
}

- (void)setUseridx:(NSString *)useridx {
  _useridx = useridx;
}

- (NSUInteger)newStar {
  return _newStar;
}

- (void)setNewStar:(NSUInteger)newStar {
  _newStar = newStar;
}

- (NSString *)msg {
  return _msg;
}

- (void)setMsg:(NSString *)msg {
  _msg = msg;
}

#pragma mark - Core Addition

+ (instancetype)newestWithCoreNewest:(PBCNewest *)newest {
  return newest;
}

@end
