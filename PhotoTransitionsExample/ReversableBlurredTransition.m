//
//  ReversableBlurredTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "ReversableBlurredTransition.h"
#import "UIImage+ImageEffects.h"

@interface ReversableBlurredTransition ()
@property (assign, nonatomic) UIViewAnimationCurve animationCurve;
@property (strong, nonatomic) UIView *blurredView;
@end

static UIImage *snapshotView(UIView *view){
    CGSize size = CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGRect boundsToDrawIn = CGRectMake(25, 25, view.bounds.size.width-50, view.bounds.size.height-50);
    [view drawViewHierarchyInRect:boundsToDrawIn afterScreenUpdates:NO];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

@implementation ReversableBlurredTransition

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.startingFrame = startingFrame;
        self.duration = 0.6f;
        self.animationCurve = UIViewAnimationCurveEaseIn;
        self.reverse = NO;
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
    
    if (self.reverse) {
        [self animateReverseTransition];
    }else{
        [self animateForwardTransition];
    }
}

- (void)animateForwardTransition
{
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [self.context containerView];
    UIView *toView = toVC.view;
    CGRect originalFrame = toView.frame;
    
    UIImage *blurredSnapshot = [snapshotView(fromVC.view) applyBlurWithRadius:1.0
                                                                    tintColor:nil
                                                        saturationDeltaFactor:0.1
                                                                    maskImage:nil];
    
    self.blurredView = [[UIImageView alloc] initWithImage:blurredSnapshot];
    self.blurredView.frame = CGRectMake(-25, -25,
                                   containerView.bounds.size.width+50,
                                   containerView.bounds.size.height+50);
    
    [containerView addSubview:self.blurredView];
    fromVC.view.alpha = 0;
    
    toView.frame = self.startingFrame;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGFloat containerHeight = CGRectGetHeight(self.context.containerView.frame);
                         CGFloat originalHeight = CGRectGetHeight(originalFrame);
                         
                         CGFloat coordinateY = (containerHeight / 2) - (originalHeight / 2);
                         
                         toView.frame = CGRectMake(0, coordinateY, CGRectGetWidth(originalFrame), CGRectGetHeight(originalFrame));
                         
                         self.blurredView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                     } completion:^(BOOL finished) {
                         [self.context completeTransition:YES];
                     }];
}

- (void)animateReverseTransition
{
    UIViewController *fromVC = [self.context
                                viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.context
                                viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         fromVC.view.frame = self.startingFrame;
                         self.blurredView.transform = CGAffineTransformIdentity;
                         
                     } completion:^(BOOL finished) {
                         toVC.view.alpha = 100;
                         [self.context completeTransition:YES];
                     }];

}

@end
