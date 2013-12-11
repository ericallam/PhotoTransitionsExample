//
//  BasicScaleTransition.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicScaleTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithStartingPoint:(CGPoint)startingPoint;

@end
