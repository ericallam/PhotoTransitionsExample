//
//  PhotoViewController1.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "PhotoViewController1.h"

@interface PhotoViewController1 ()

@end

@implementation PhotoViewController1


- (IBAction)dismissPhoto:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
