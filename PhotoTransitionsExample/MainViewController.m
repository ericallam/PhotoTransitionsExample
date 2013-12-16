//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"
#import "PhotoViewController1.h"
#import "PhotoViewController2.h"
#import "PhotoViewController3.h"
#import "PhotoViewController4.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate>
@end

@implementation MainViewController

- (IBAction)defaultModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    PhotoViewController1 *photoVC = [PhotoViewController1 new];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

//- (IBAction)presentPhoto:(UIControl *)sender
//{
//    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
//    
//    PhotoViewController2 *photoVC = [[PhotoViewController2 alloc]
//                                        initWithStartingFrame:senderFrame];
//    
//    photoVC.modalPresentationStyle = UIModalPresentationCustom;
//    photoVC.transitioningDelegate = photoVC;
//    
//    [self presentViewController:photoVC animated:YES completion:nil];
//}

- (IBAction)basicScaleModal:(UIControl *)sender forEvent:(UIEvent *)event
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoViewController2 *photoVC = [[PhotoViewController2 alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)blurredBackgroundModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoViewController3 *photoVC = [[PhotoViewController3 alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)blurredReversableModal:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoViewController4 *photoVC = [[PhotoViewController4 alloc] initWithStartingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (IBAction)fullTransition:(UIControl *)sender
{
    CGRect senderFrame = [sender convertRect:sender.bounds toView:nil];
    
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow2"]
                                                                startingFrame:senderFrame];
    
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    photoVC.transitioningDelegate = photoVC;
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

@end
