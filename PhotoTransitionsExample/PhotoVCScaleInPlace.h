//
//  PhotoViewController2.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//

#import <UIKit/UIKit.h>

@interface PhotoVCScaleInPlace : UIViewController
                                    <UIViewControllerTransitioningDelegate>
- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
@end
