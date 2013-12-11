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

- (instancetype)initWithStartingPoint:(CGPoint)startingPoint;
{
    if (self = [super init]) {
        self.startingPoint = startingPoint;
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
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    toView.center = self.startingPoint;
    
    CGAffineTransform t = CGAffineTransformIdentity;
    
    t = CGAffineTransformScale(t, 0.2f, 0.2f);
    
    toView.transform = t;
    
    [[self.context containerView] addSubview:toView];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    [UIView setAnimationDuration:self.duration];
    [UIView setAnimationCurve:self.animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    toView.transform = CGAffineTransformIdentity;
    toView.center = fromVC.view.center;
    fromVC.view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    [self.context completeTransition:YES];
}

@end
