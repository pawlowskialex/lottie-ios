//
//  LOTShapeStar.m
//  Lottie
//
//  Created by Alex Pawlowski on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTShapeStar.h"
#import "LOTAnimatablePointValue.h"
#import "LOTAnimatableScaleValue.h"
#import "LOTAnimatableNumberValue.h"

@implementation LOTShapeStar

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary frameRate:(NSNumber *)frameRate {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary frameRate:frameRate];
  }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary frameRate:(NSNumber *)frameRate {
  NSDictionary *position = jsonDictionary[@"p"];
  if (position) {
    _position = [[LOTAnimatablePointValue alloc] initWithPointValues:position frameRate:frameRate];
    _position.usePathAnimation = NO;
  }
  
  NSDictionary *points = jsonDictionary[@"pt"];
  if (points) {
    _points = [[LOTAnimatableNumberValue alloc] initWithNumberValues:points frameRate:frameRate];
  }
  
  NSDictionary *rotation = jsonDictionary[@"r"];
  if (rotation) {
    _rotation = [[LOTAnimatableNumberValue alloc] initWithNumberValues:rotation frameRate:frameRate];
  }
  
  NSDictionary *outerRadius = jsonDictionary[@"or"];
  if (outerRadius) {
    _outerRadius = [[LOTAnimatableNumberValue alloc] initWithNumberValues:outerRadius frameRate:frameRate];
  }
  
  NSDictionary *outerRoundness = jsonDictionary[@"os"];
  if (outerRoundness) {
    _outerRoundness = [[LOTAnimatableNumberValue alloc] initWithNumberValues:outerRoundness frameRate:frameRate];
  }
}

@end
