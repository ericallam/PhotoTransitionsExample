//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@end

@implementation MainViewController

- (IBAction)defaultModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow1"]];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)basicScaleModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow2"]
                                                                startingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

@end
