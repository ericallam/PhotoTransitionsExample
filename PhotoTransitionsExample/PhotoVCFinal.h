//
//  PhotoVCFinal.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.

#import <UIKit/UIKit.h>

@interface PhotoVCFinal : UIViewController <UIViewControllerTransitioningDelegate>
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image startingFrame:(CGRect)startingFrame;
@end
