//
//  BasicScaleTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "BasicScaleTransition.h"

@interface BasicScaleTransition ()
@property (assign, nonatomic) CGPoint startingPoint;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> context;
@property (assign, nonatomic) NSTimeInterval duration;
@end

@implementation BasicScaleTransition

- (instancetype)initWithStartingPoint:(CGPoint)startingPoint;
{
    if (self = [super init]) {
        self.startingPoint = startingPoint;
        self.duration = 1.0f;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    toView.center = self.startingPoint;
    
    CGAffineTransform t = CGAffineTransformIdentity;
    
    t = CGAffineTransformScale(t, 0.2f, 0.2f);
    
    toView.transform = t;
    
    [[self.context containerView] addSubview:toView];
    
    [UIView animateWithDuration:self.duration delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toView.transform = CGAffineTransformIdentity;
        toView.center = fromVC.view.center;
        
    } completion:^(BOOL finished) {
        [self.context completeTransition:YES];
    }];
}

@end
