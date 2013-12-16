//
//  PhotoViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "PhotoVCFinal.h"
#import "FinalTransition.h"

@interface PhotoVCFinal ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) FinalTransition *scaleAndBlurTransition;
@property (strong, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransition;
@end

@implementation PhotoVCFinal

- (instancetype)initWithImage:(UIImage *)image;
{
    return [self initWithImage:image startingFrame:CGRectInfinite];
}

- (instancetype)initWithImage:(UIImage *)image startingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.image = image;
        self.scaleAndBlurTransition = [[FinalTransition alloc] initWithStartingFrame:startingFrame];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:self.image];
    
    CGFloat ratio = CGRectGetHeight(self.view.frame) / CGRectGetWidth(self.view.frame);
    
    self.view.frame = CGRectMake(0, 0, 320, 320*ratio);
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
}

- (void)didPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.superview];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            [self.animator removeAllBehaviors];
            
            UIDynamicItemBehavior *rotationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
            rotationBehavior.allowsRotation = YES;
            rotationBehavior.angularResistance = 10.0f;
            
            [self.animator addBehavior:rotationBehavior];

            CGPoint viewCenter = self.view.center;
            
            UIOffset centerOffset = UIOffsetMake(location.x - viewCenter.x, location.y - viewCenter.y);
            
            self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.view offsetFromCenter:centerOffset attachedToAnchor:location];
            self.panAttachment.damping = 0.7f;
            self.panAttachment.length = 0;
            [self.animator addBehavior:self.panAttachment];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.panAttachment.anchorPoint = location;
            
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gesture velocityInView:self.view.superview];
            
            if (fabs(velocity.x) > 400 || fabs(velocity.y) > 400) {
                // "Finish" the dismissal
                [self.animator removeBehavior:self.panAttachment];
                
                self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.view] mode:UIPushBehaviorModeInstantaneous];
                self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10.0f, velocity.y / 10.0f);
                
                [self.animator addBehavior:self.pushBehavior];
                
                __weak typeof(self) weakSelf = self;
                
                self.pushBehavior.action = ^{
                    if (!CGRectIntersectsRect(weakSelf.view.frame, weakSelf.view.superview.frame)) {
                        
                        [weakSelf.animator removeAllBehaviors];
                        
                        weakSelf.scaleAndBlurTransition.destinationViewAlreadyOutOfFrame = YES;
                        
                        weakSelf.interactiveTransition = nil;
                        
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                };
            }else{
                // "Cancel" the dismissal
                
                [self.animator removeAllBehaviors];
                
                UISnapBehavior *snapIt = [[UISnapBehavior alloc] initWithItem:self.view snapToPoint:CGPointMake(160, 284)];
                snapIt.damping = 0.7;
                
                [self.animator addBehavior:snapIt];
                
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)gesture
{
    self.interactiveTransition = nil;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [[[UIApplication sharedApplication] keyWindow] removeGestureRecognizer:gesture];
}

- (void)didPinch:(UIPinchGestureRecognizer *)gesture
{
    UIPercentDrivenInteractiveTransition *transition = (UIPercentDrivenInteractiveTransition *)self.interactiveTransition;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (gesture.scale > 1.0) {
                self.view.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
            }else{
                [transition updateInteractiveTransition:1.0-gesture.scale];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            transition.completionSpeed = MIN(MAX(fabs(gesture.velocity), 0.1), 1.5);
            
            if (gesture.scale < 0.5) {
                [transition finishInteractiveTransition];
            }else{
                [transition cancelInteractiveTransition];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.scaleAndBlurTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.scaleAndBlurTransition.reverse = YES;
    
    return self.scaleAndBlurTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition;
    
    // Could be a pinch gesture (PercentDriven)
    // Could be a swipe (Uses dynamic attaching and push, does not use PercentDriven
    
    // Could be nothing
}

@end
