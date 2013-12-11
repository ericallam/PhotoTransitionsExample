//
//  BasicScaleTransition.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicScaleTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) id<UIViewControllerContextTransitioning> context;
@property (assign, nonatomic) CGPoint startingPoint;
@property (assign, atomic) NSTimeInterval duration;

- (instancetype)initWithStartingPoint:(CGPoint)startingPoint;

@end
