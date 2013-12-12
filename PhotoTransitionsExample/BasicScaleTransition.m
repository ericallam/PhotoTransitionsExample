//
//  BasicScaleTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "BasicScaleTransition.h"

@interface BasicScaleTransition ()
@property (assign, atomic) UIViewAnimationCurve animationCurve;
@end

@implementation BasicScaleTransition

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.startingFrame = startingFrame;
        self.duration = 0.4f;
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
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    
    CGRect originalFrame = toView.frame;

    toView.frame = self.startingFrame;
    
    [[self.context containerView] addSubview:toView];
    
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
    fromVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    [self.context completeTransition:YES];
}

@end
