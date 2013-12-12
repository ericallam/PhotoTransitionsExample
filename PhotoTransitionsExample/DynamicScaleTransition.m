//
//  DynamicScaleTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 11/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "DynamicScaleTransition.h"

@interface DynamicScaleTransition ()
@property (strong, nonatomic) UIDynamicAnimator *animator;
@end

@implementation DynamicScaleTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
//    self.context = transitionContext;
//    
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.context.containerView];
//    
//    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
//    
//    UIView *toView = toVC.view;
//    toView.center = self.startingPoint;
//    
//    [[self.context containerView] addSubview:toView];
//    
//    CGPoint screenCenter = self.context.containerView.center;
//    
//    NSLog(@"screenCenter: %@", NSStringFromCGPoint(screenCenter));
//    
//    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:toView attachedToAnchor:screenCenter];
//    attachment.damping = 0.5f;
//    attachment.frequency = 0.3f;
//    
//    attachment.action = ^{
//        NSLog(@"self.animator.elapsedTime: %f  self.duration: %f", self.animator.elapsedTime, self.duration);
//        
//        if (self.animator.elapsedTime >= self.duration) {
//            [self.animator removeAllBehaviors];
//            [self.context completeTransition:YES];
//        }
//    };
//    
//    [self.animator addBehavior:attachment];
}

@end
