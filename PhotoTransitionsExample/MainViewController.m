//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoVCFinal.h"
#import "PhotoVCDefault.h"
#import "PhotoVCScaleInPlace.h"
#import "PhotoVCBlurredBackground.h"
#import "PhotoVCReversable.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@end

@implementation MainViewController

- (IBAction)defaultModal:(UIControl *)sender
{
    PhotoVCDefault *photoVC = [PhotoVCDefault new];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)scaleInPlaceModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCScaleInPlace *photoVC = [[PhotoVCScaleInPlace alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)blurredBackgroundModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCBlurredBackground *photoVC = [[PhotoVCBlurredBackground alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)blurredReversableModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoVCReversable *photoVC = [[PhotoVCReversable alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

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
