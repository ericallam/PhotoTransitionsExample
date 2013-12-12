//
//  PhotoViewController.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIViewControllerTransitioningDelegate>
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image startingFrame:(CGRect)startingFrame;
@end
