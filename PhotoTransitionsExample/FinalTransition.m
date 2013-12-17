//
//  FinalTransition.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 12/12/2013.

#import "FinalTransition.h"
#import "UIImage+ImageEffects.h"

@interface FinalTransition ()

@property (assign, atomic) UIViewAnimationCurve animationCurve;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> context;
@property (assign, nonatomic) CGRect startingFrame;
@property (assign, atomic) NSTimeInterval duration;

@property (strong, nonatomic) UIView *blurredView;

@end

// Creates a snapshot of the view using the new drawViewHierarchyInRect:afterScreenUpdates: method
// Notice how the rect passed into the inRect: argument is larger than the bounds of the view. This
// is to create a 25pt black border around the view in the image, so when the image is blurred the sides
// are also blurred.
static UIImage *snapshotView(UIView *view){
    CGSize size = CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    CGRect boundsToDrawIn = CGRectMake(25, 25, view.bounds.size.width-50, view.bounds.size.height-50);
    [view drawViewHierarchyInRect:boundsToDrawIn afterScreenUpdates:NO];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

@implementation FinalTransition

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.startingFrame = startingFrame;
        self.duration = 0.2f;
        self.animationCurve = UIViewAnimationCurveEaseIn;
        self.reverse = NO;
        self.animateForegroundBackToStartingFrame = YES;
        
        // If the keyboard is hidden, we'll know about it
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

// Change the duration and animation curve of this animation if the keyboard is also being dismissed
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.duration = [[aNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.animationCurve = [[aNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
}

#pragma mark - Animated transitioning delegate method

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    if (self.reverse) {
        [self animateReverseTransition];
    }else{
        [self animateForwardTransition];
    }
}

#pragma mark - Forward/Reverse

- (void)animateForwardTransition
{
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [self.context containerView];
    
    UIImage *fromSnapshot = [snapshotView(fromVC.view) applyBlurWithRadius:1.0
                                                                 tintColor:nil
                                                     saturationDeltaFactor:0.1
                                                                 maskImage:nil];
    
    self.blurredView = [[UIImageView alloc] initWithImage:fromSnapshot];
    
    self.blurredView.frame = CGRectMake(-25, -25, containerView.bounds.size.width+50, containerView.bounds.size.height+50);
    
    [containerView addSubview:self.blurredView];
    
    fromVC.view.alpha = 0;
    
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    CGRect originalFrame = toView.frame;
    toView.frame = self.startingFrame;
    
    [containerView addSubview:toView];
    
#pragma message("Use new block-based API once rdar://15641270 has been fixed")
    
    // Use old-school style animations just in case we need to use the keyboard dismissal
    // animation curve (it's unsupported by the new block-based animation API, which if you could please dup
    // rdar://15641270 for me that would be nice)
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
    self.blurredView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
    
    [UIView commitAnimations];
}

- (void)animateReverseTransition
{
    UIViewController *fromVC = [self.context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [self.context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.blurredView.transform = CGAffineTransformIdentity;
                         
                         if (self.animateForegroundBackToStartingFrame) {
                             fromVC.view.frame = self.startingFrame;
                         }
                         
                     } completion:^(BOOL finished) {
                         toVC.view.alpha = 100;
                         [self.context completeTransition:![self.context transitionWasCancelled]];
                     }];
    
}

#pragma mark - Animation stopped

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
    // If the transition was cancelled (which can happen if the transition is interactive)
    // then pass in NO to the completeTransition: method. This will tell the system not do
    // anything with the hierarchy
    [self.context completeTransition:![self.context transitionWasCancelled]];
}


@end
