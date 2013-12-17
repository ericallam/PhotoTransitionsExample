//
//  PhotoViewController1.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//

#import "PhotoVCDefault.h"

@interface PhotoVCDefault ()

@end

@implementation PhotoVCDefault


- (IBAction)dismissPhoto:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
