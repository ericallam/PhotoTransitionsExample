//
//  BlurredBackgroundTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "BlurredBackgroundTransition.h"
#import "UIImage+ImageEffects.h"

@interface BlurredBackgroundTransition ()
@property (assign, nonatomic) UIViewAnimationCurve animationCurve;
@property (strong, nonatomic) UIView *sourcePlaceholderView;
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

@implementation BlurredBackgroundTransition

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
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [context containerView];
    UIView *toView = toVC.view;
    CGRect originalFrame = toView.frame;
    
    UIImage *blurredSnapshot = [snapshotView(fromVC.view) applyBlurWithRadius:1.0
                                                                    tintColor:nil
                                                        saturationDeltaFactor:0.1
                                                                    maskImage:nil];
    
    UIImageView *blurredView = [[UIImageView alloc] initWithImage:blurredSnapshot];
    blurredView.frame = CGRectMake(-25, -25,
                                    containerView.bounds.size.width+50,
                                    containerView.bounds.size.height+50);
    
    [containerView addSubview:blurredView];
    fromVC.view.alpha = 0;
    
    toView.frame = self.startingFrame;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:self.duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        CGFloat containerHeight = CGRectGetHeight(context.containerView.frame);
        CGFloat originalHeight = CGRectGetHeight(originalFrame);
        
        CGFloat coordinateY = (containerHeight / 2) - (originalHeight / 2);
        
        toView.frame = CGRectMake(0, coordinateY, CGRectGetWidth(originalFrame), CGRectGetHeight(originalFrame));
        
        blurredView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    } completion:^(BOOL finished) {
        [context completeTransition:YES];
    }];
}

@end
