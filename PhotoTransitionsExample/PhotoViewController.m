//
//  PhotoViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "PhotoViewController.h"
#import "ScaleAndBlurTransition.h"

@interface PhotoViewController ()
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) ScaleAndBlurTransition *scaleAndBlurTransition;
@property (strong, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransition;
@end

@implementation PhotoViewController

- (instancetype)initWithImage:(UIImage *)image;
{
    return [self initWithImage:image startingFrame:CGRectInfinite];
}

- (instancetype)initWithImage:(UIImage *)image startingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.image = image;
        self.scaleAndBlurTransition = [[ScaleAndBlurTransition alloc] initWithStartingFrame:startingFrame];
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
