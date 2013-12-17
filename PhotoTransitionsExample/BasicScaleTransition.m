//
//  BasicScaleTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "BasicScaleTransition.h"

@interface BasicScaleTransition ()
@property (assign, nonatomic) UIViewAnimationCurve animationCurve;
@end

@implementation BasicScaleTransition

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.startingFrame = startingFrame;
        self.duration = 0.2f;
        self.animationCurve = UIViewAnimationCurveEaseIn;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)context
{
    self.context = context;
    
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    
    CGRect originalFrame = toView.frame;

    toView.frame = self.startingFrame;
    
    [[context containerView] addSubview:toView];
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGFloat containerHeight = CGRectGetHeight(self.context.containerView.frame);
        CGFloat originalHeight = CGRectGetHeight(originalFrame);
        
        CGFloat coordinateY = (containerHeight / 2) - (originalHeight / 2);
        
        toView.frame = CGRectMake(0, coordinateY, CGRectGetWidth(originalFrame), CGRectGetHeight(originalFrame));
    } completion:^(BOOL finished) {
        [self.context completeTransition:YES];
    }];
}

@end
