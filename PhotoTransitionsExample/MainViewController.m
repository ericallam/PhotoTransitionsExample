//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"
#import "BasicScaleTransition.h"
#import "DynamicScaleTransition.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@property (assign, nonatomic) CGRect currentFrame;
@end

@implementation MainViewController

- (IBAction)defaultModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow1"]];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)basicScaleModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow2"]];
    
    self.currentFrame = [sender convertRect:sender.bounds toView:nil];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = self;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    BasicScaleTransition *transition = [[BasicScaleTransition alloc] initWithStartingFrame:self.currentFrame];
    
    return transition;
}

@end
