//
//  PhotoViewController2.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//

#import "PhotoVCScaleInPlace.h"
#import "BasicScaleTransition.h"

@interface PhotoVCScaleInPlace ()
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) CGRect startingFrame;
@property (strong, nonatomic) BasicScaleTransition *scaleTransition;
@end

@implementation PhotoVCScaleInPlace

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
{
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"PiperWow2"];
        self.startingFrame = startingFrame;
        self.scaleTransition = [[BasicScaleTransition alloc] initWithStartingFrame:self.startingFrame];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:self.image];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat ratio = CGRectGetHeight(self.view.frame) / CGRectGetWidth(self.view.frame);
    
    self.view.frame = CGRectMake(0, 0, 320, ceilf(320*ratio));
    self.view.userInteractionEnabled = YES;
}

- (void)viewTapped:(UITapGestureRecognizer *)gesture
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [[[UIApplication sharedApplication] keyWindow] removeGestureRecognizer:gesture];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[BasicScaleTransition alloc] initWithStartingFrame:self.startingFrame];
}



@end