//
//  ScaleAndBlurTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 12/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "ScaleAndBlurTransition.h"
#import "UIImage+ImageEffects.h"

@interface ScaleAndBlurTransition ()

@property (assign, atomic) UIViewAnimationCurve animationCurve;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> context;
@property (assign, nonatomic) CGRect startingFrame;
@property (assign, atomic) NSTimeInterval duration;

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

@implementation ScaleAndBlurTransition

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.startingFrame = startingFrame;
        self.duration = 0.2f;
        self.animationCurve = UIViewAnimationCurveEaseIn;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.animationCurve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [self.context containerView];
    
    UIImage *fromSnapshotBeforeBlur = snapshotView(fromVC.view);
    UIImage *fromSnapshot = [fromSnapshotBeforeBlur applyBlurWithRadius:1.0 tintColor:nil saturationDeltaFactor:0.1 maskImage:nil];
    UIImageView *fromSnapshotView = [[UIImageView alloc] initWithImage:fromSnapshot];
    
    fromSnapshotView.frame = CGRectMake(-25, -25, containerView.bounds.size.width+50, containerView.bounds.size.height+50);
    [containerView addSubview:fromSnapshotView];
    
    [fromVC.view removeFromSuperview];
    
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    
    CGRect originalFrame = toView.frame;
    
    toView.frame = self.startingFrame;
    
    [containerView addSubview:toView];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    [UIView setAnimationDuration:self.duration];
    [UIView setAnimationCurve:self.animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGFloat containerHeight = CGRectGetHeight(self.context.containerView.frame);
    CGFloat originalHeight = CGRectGetHeight(originalFrame);
    
    CGFloat coordinateY = (containerHeight / 2) - (originalHeight / 2);
    toView.frame = CGRectMake(0, coordinateY, CGRectGetWidth(originalFrame), CGRectGetHeight(originalFrame));
    fromSnapshotView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    [self.context completeTransition:YES];
}


@end
