//
//  LOTStarShapeLayer.h
//  Lottie
//
//  Created by Alex Pawlowski on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTAnimatableLayer.h"
#import "LOTModels.h"

@interface LOTStarShapeLayer : LOTAnimatableLayer

- (instancetype)initWithStarShape:(LOTShapeStar *)starShape
                             fill:(LOTShapeFill *)fill
                           stroke:(LOTShapeStroke *)stroke
                             trim:(LOTShapeTrimPath *)trim
                        transform:(LOTShapeTransform *)transform
                withLayerDuration:(NSTimeInterval)duration;

@end
