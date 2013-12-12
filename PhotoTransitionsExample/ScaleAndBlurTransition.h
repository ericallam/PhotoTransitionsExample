//
//  ScaleAndBlurTransition.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 12/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleAndBlurTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;

@property (assign, nonatomic) BOOL reverse;
@property (strong, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransition;

@end
