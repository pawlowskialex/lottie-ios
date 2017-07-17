//
//  LOTShapeStar.h
//  Lottie
//
//  Created by Alex Pawlowski on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LOTAnimatablePointValue;
@class LOTAnimatableScaleValue;
@class LOTAnimatableNumberValue;

@interface LOTShapeStar : NSObject

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary frameRate:(NSNumber *)frameRate;

@property (nonatomic, readonly) LOTAnimatablePointValue *position;
@property (nonatomic, readonly) LOTAnimatableNumberValue *outerRadius;
@property (nonatomic, readonly) LOTAnimatableNumberValue *outerRoundness;
@property (nonatomic, readonly) LOTAnimatableNumberValue *rotation;
@property (nonatomic, readonly) LOTAnimatableNumberValue *points;

@end
