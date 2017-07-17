//
//  LOTStarShapeLayer.m
//  Lottie
//
//  Created by Alex Pawlowski on 7/17/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTStarShapeLayer.h"
#import "CAAnimationGroup+LOTAnimatableGroup.h"
#import "LOTStrokeShapeLayer.h"
#import "LOTHelpers.h"

@interface LOTStarShapeLayer_ : LOTStrokeShapeLayer

@property (nonatomic) NSInteger starPoints;
@property (nonatomic) CGPoint starPosition;
@property (nonatomic) CGFloat starRadius;
@property (nonatomic) CGFloat starRotation;

@end

@implementation LOTStarShapeLayer_

@dynamic starPoints;
@dynamic starPosition;
@dynamic starRadius;
@dynamic starRotation;

-(id)initWithLayer:(id)layer {
  if( ( self = [super initWithLayer:layer] ) ) {
    if ([layer isKindOfClass:[LOTStarShapeLayer_ class]]) {
      self.starPoints = ((LOTStarShapeLayer_ *)layer).starPoints;
      self.starPosition = ((LOTStarShapeLayer_ *)layer).starPosition;
      self.starRadius = ((LOTStarShapeLayer_ *)layer).starRadius;
      self.starRotation = ((LOTStarShapeLayer_ *)layer).starRotation;
    }
  }
  return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
  BOOL needsDisplay = [super needsDisplayForKey:key];
  
  if ([key isEqualToString:@"starPoints"] ||
      [key isEqualToString:@"starPosition"] ||
      [key isEqualToString:@"starRadius"] ||
      [key isEqualToString:@"starRotation"]) {
    needsDisplay = YES;
  }
  
  return needsDisplay;
}

-(id<CAAction>)actionForKey:(NSString *)event {
  if([event isEqualToString:@"starPoints"] ||
     [event isEqualToString:@"starPosition"] ||
     [event isEqualToString:@"starRadius"] ||
     [event isEqualToString:@"starRotation"]) {
    CABasicAnimation *theAnimation = [CABasicAnimation
                                      animationWithKeyPath:event];
    theAnimation.fromValue = [[self presentationLayer] valueForKey:event];
    return theAnimation;
  }
  return [super actionForKey:event];
}

- (void)_setPath {
  LOTStarShapeLayer_ *presentationStar = (LOTStarShapeLayer_ *)self.presentationLayer;
  if (presentationStar == nil) {
    presentationStar = self;
  }
  CGFloat radius = presentationStar.starRadius;
  CGFloat angle = (2.0 * M_PI) / presentationStar.starPoints;
  
  UIBezierPath *path = [UIBezierPath bezierPath];
  
  [path moveToPoint:CGPointMake(radius, 0.0)];
  
  for (NSInteger point = 1; point < presentationStar.starPoints; point++) {
    CGFloat x = radius * cos(point * angle);
    CGFloat y = radius * sin(point * angle);
    
    [path addLineToPoint:CGPointMake(x, y)];
  }
  
  [path applyTransform:CGAffineTransformMakeRotation(-M_PI_2)];
  [path applyTransform:CGAffineTransformMakeTranslation(presentationStar.starPosition.x,
                                                        presentationStar.starPosition.y)];
  [path applyTransform:CGAffineTransformMakeRotation(LOT_DegreesToRadians(presentationStar.starRotation))];
  
  self.path = path.CGPath;
}

- (void)display {
  [self _setPath];
  [super display];
}

@end

@implementation LOTStarShapeLayer {
  LOTShapeTransform *_transform;
  LOTShapeStroke *_stroke;
  LOTShapeFill *_fill;
  LOTShapeStar *_star;
  LOTShapeTrimPath *_trim;
  
  LOTStarShapeLayer_ *_fillLayer;
  LOTStarShapeLayer_ *_strokeLayer;
  
  CAAnimationGroup *_animation;
  CAAnimationGroup *_strokeAnimation;
  CAAnimationGroup *_fillAnimation;
}

- (instancetype)initWithStarShape:(LOTShapeStar *)starShape
                             fill:(LOTShapeFill *)fill
                           stroke:(LOTShapeStroke *)stroke
                             trim:(LOTShapeTrimPath *)trim
                        transform:(LOTShapeTransform *)transform
                withLayerDuration:(NSTimeInterval)duration {
  self = [super initWithLayerDuration:duration];
  if (self) {
    _star = starShape;
    _stroke = stroke;
    _fill = fill;
    _transform = transform;
    _trim = trim;
    
    self.allowsEdgeAntialiasing = YES;
    self.frame = _transform.compBounds;
    self.anchorPoint = _transform.anchor.initialPoint;
    self.opacity = _transform.opacity.initialValue.floatValue;
    self.position = _transform.position.initialPoint;
    self.transform = _transform.scale.initialScale;
    self.sublayerTransform = CATransform3DMakeRotation(_transform.rotation.initialValue.floatValue, 0, 0, 1);
    
    if (fill) {
      _fillLayer = [LOTStarShapeLayer_ new];
      _fillLayer.allowsEdgeAntialiasing = YES;
      _fillLayer.fillColor = _fill.color.initialColor.CGColor;
      _fillLayer.opacity = _fill.opacity.initialValue.floatValue;
      _fillLayer.starPoints = starShape.points.initialValue.integerValue;
      _fillLayer.starRadius = starShape.outerRadius.initialValue.floatValue;
      _fillLayer.starPosition = starShape.position.initialPoint;
      _fillLayer.starRotation = starShape.rotation.initialValue.floatValue;
      [self addSublayer:_fillLayer];
    }
    
    if (stroke) {
      _strokeLayer = [LOTStarShapeLayer_ new];
      _strokeLayer.allowsEdgeAntialiasing = YES;
      _strokeLayer.strokeColor = _stroke.color.initialColor.CGColor;
      _strokeLayer.opacity = _stroke.opacity.initialValue.floatValue;
      _strokeLayer.lineWidth = _stroke.width.initialValue.floatValue;
      _strokeLayer.fillColor = nil;
      _strokeLayer.backgroundColor = nil;
      _strokeLayer.lineDashPattern = _stroke.lineDashPattern;
      _strokeLayer.lineCap = _stroke.capType == LOTLineCapTypeRound ? kCALineCapRound : kCALineCapButt;
      _strokeLayer.starPoints = starShape.points.initialValue.integerValue;
      _strokeLayer.starRadius = starShape.outerRadius.initialValue.floatValue;
      _strokeLayer.starPosition = starShape.position.initialPoint;
      _strokeLayer.starRotation = starShape.rotation.initialValue.floatValue;
      switch (_stroke.joinType) {
          case LOTLineJoinTypeBevel:
          _strokeLayer.lineJoin = kCALineJoinBevel;
          break;
          case LOTLineJoinTypeMiter:
          _strokeLayer.lineJoin = kCALineJoinMiter;
          break;
          case LOTLineJoinTypeRound:
          _strokeLayer.lineJoin = kCALineJoinRound;
          break;
        default:
          break;
      }
      if (trim) {
        _strokeLayer.trimStart = _trim.start.initialValue.floatValue;
        _strokeLayer.trimEnd = _trim.end.initialValue.floatValue;
        _strokeLayer.trimOffset = _trim.offset.initialValue.floatValue;
      }
      [self addSublayer:_strokeLayer];
    }
    
    [self _buildAnimation];
  }
  
  return self;
}

- (void)_buildAnimation {
  if (_transform) {
    _animation = [CAAnimationGroup LOT_animationGroupForAnimatablePropertiesWithKeyPaths:@{@"opacity" : _transform.opacity,
                                                                                           @"position" : _transform.position,
                                                                                           @"anchorPoint" : _transform.anchor,
                                                                                           @"transform" : _transform.scale,
                                                                                           @"sublayerTransform.rotation" : _transform.rotation}];
    [self addAnimation:_animation forKey:@"LottieAnimation"];
  }
  
  if (_stroke) {
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:@{@"strokeColor" : _stroke.color,
                                                                                      @"opacity" : _stroke.opacity,
                                                                                      @"lineWidth" : _stroke.width}];
    if (_trim) {
      properties[@"trimStart"] = _trim.start;
      properties[@"trimEnd"] = _trim.end;
      properties[@"trimOffset"] = _trim.offset;
    }
    _strokeAnimation = [CAAnimationGroup LOT_animationGroupForAnimatablePropertiesWithKeyPaths:properties];
    [_strokeLayer addAnimation:_strokeAnimation forKey:@""];
    
  }
  
  if (_fill) {
    _fillAnimation = [CAAnimationGroup LOT_animationGroupForAnimatablePropertiesWithKeyPaths:@{@"fillColor" : _fill.color,
                                                                                               @"opacity" : _fill.opacity}];
    [_fillLayer addAnimation:_fillAnimation forKey:@""];
  }
}

@end
