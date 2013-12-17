//
//  PhotoViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.

#import "PhotoVCFinal.h"
#import "FinalTransition.h"

@interface PhotoVCFinal ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) FinalTransition *animatedTransition;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation PhotoVCFinal

#pragma mark - Initializers

- (instancetype)initWithImage:(UIImage *)image;
{
    return [self initWithImage:image startingFrame:CGRectInfinite];
}

- (instancetype)initWithImage:(UIImage *)image startingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.image = image;
        self.animatedTransition = [[FinalTransition alloc] initWithStartingFrame:startingFrame];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:self.image];
    CGFloat ratio = CGRectGetHeight(self.view.frame) / CGRectGetWidth(self.view.frame);
    
    self.view.frame = CGRectMake(0, 0, 320, 320*ratio);
    self.view.userInteractionEnabled = YES;
    
    // Tap anywhere to dismiss
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:tapGesture];
    
    // Pinch for an interactive dismissal
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    // Pan for a dismissal using UIKit Dynamics
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    // The animator's reference view is this view's superview, aka the transition 'container view'
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
}

#pragma mark - Gesture recognizer actions

- (void)didPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.view.superview];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // Cleanup existing behaviors like the "snap" behavior when, after a pan starts, this view
            // gets snapped back into place
            [self.animator removeAllBehaviors];
            
            // Give the view some rotation
            UIDynamicItemBehavior *rotationBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
            rotationBehavior.allowsRotation = YES;
            rotationBehavior.angularResistance = 10.0f;
            
            [self.animator addBehavior:rotationBehavior];

            // Calculate the offset from the center of the view to use in the attachment behavior
            CGPoint viewCenter = self.view.center;
            UIOffset centerOffset = UIOffsetMake(location.x - viewCenter.x, location.y - viewCenter.y);
            
            // Attach to the location of the pan in the container view.
            self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.view
                                                           offsetFromCenter:centerOffset
                                                           attachedToAnchor:location];
            self.panAttachment.damping = 0.7f;
            self.panAttachment.length = 0;
            [self.animator addBehavior:self.panAttachment];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // Now when the finger moves around we just update the anchor point,
            // which will move the view around
            self.panAttachment.anchorPoint = location;
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [gesture velocityInView:self.view.superview];
            
            BOOL velocityThresholdReached = fabs(velocity.x) > 400 || fabs(velocity.y) > 400;
            
            if (velocityThresholdReached) {
                [self.animator removeBehavior:self.panAttachment];
                
                // Give the view a little push, based on the velocity of the gesture when it ended
                self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.view] mode:UIPushBehaviorModeInstantaneous];
                self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10.0f, velocity.y / 10.0f);
                
                [self.animator addBehavior:self.pushBehavior];

                __weak typeof(self) weakSelf = self;
                
                self.pushBehavior.action = ^{
                    BOOL viewOutOfFrame = !CGRectIntersectsRect(weakSelf.view.frame, weakSelf.view.superview.frame);
                    
                    if (viewOutOfFrame) {
                        [weakSelf.animator removeAllBehaviors];
                        
                        weakSelf.animatedTransition.animateForegroundBackToStartingFrame = NO;
                        
                        // Kick off the dismissal transition
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                };
            }else{
                
                // Not enough velocity to exit the modal, so snap it back into the center of the screen
                [self.animator removeAllBehaviors];
                
                #pragma message("Don't hard-code the center like that")
                
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

// Pinching to dismiss uses an interactive transition
// interactive transitions work together with the animated transition
- (void)didPinch:(UIPinchGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // When the pinch starts, assign a interactive transition and then dimiss the controller
            self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                self.interactiveTransition = nil; // nil out the interactive transition onces it's finished
            }];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (gesture.scale > 1.0) {
                self.view.transform = CGAffineTransformMakeScale(gesture.scale, gesture.scale);
            }else{
                [self.interactiveTransition updateInteractiveTransition:1.0-gesture.scale];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            self.interactiveTransition.completionSpeed = MIN(MAX(fabs(gesture.velocity), 0.1), 1.5);
            
            if (gesture.scale < 0.5) {
                [self.interactiveTransition finishInteractiveTransition];
            }else{
                [self.interactiveTransition cancelInteractiveTransition];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Transition delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.animatedTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animatedTransition.reverse = YES;
    
    return self.animatedTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition; // if this is nil, then the dismissal won't be interactive (which is what we want)
}

@end
