//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.

#import "MainViewController.h"
#import "PhotoVCFinal.h"
#import "PhotoVCDefault.h"
#import "PhotoVCScaleInPlace.h"
#import "PhotoVCBlurredBackground.h"
#import "PhotoVCReversable.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@end

@implementation MainViewController

// Display the photo using default modal transitions.
- (IBAction)defaultModal:(UIControl *)sender
{
    PhotoVCDefault *photoVC = [PhotoVCDefault new];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

// Display the photo using a custom presentation. Uses the BasicScaleTransition animator
- (IBAction)scaleInPlaceModal:(UIControl *)sender
{
    // Passing in nil to toView: converts the rect to the window's coordinate system
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCScaleInPlace *photoVC = [[PhotoVCScaleInPlace alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

// Display the photo using a custom presentation that also blurs and scales the background
// Uses the BlurredBackgroundTransition animator
- (IBAction)blurredBackgroundModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCBlurredBackground *photoVC = [[PhotoVCBlurredBackground alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

// Use a custom animated transition that has a "reverse" animation for the dismissal
// of this view controller
- (IBAction)blurredReversableModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCReversable *photoVC = [[PhotoVCReversable alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

// The kitchen-sink modal transition. Includes interactive dismissal transitions, dynamics, etc.
// See the PhotoVCFinal class and the FinalTransition class for more information.
- (IBAction)fullModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCFinal *photoVC = [[PhotoVCFinal alloc] initWithImage:[UIImage imageNamed:@"PiperWow2"]
                                                                startingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

@end
