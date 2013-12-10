//
//  MainViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"

@interface MainViewController ()
- (IBAction)defaultModal:(id)sender;
@end

@implementation MainViewController

- (IBAction)defaultModal:(id)sender
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithImage:[UIImage imageNamed:@"PiperWow1"]];
    
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
