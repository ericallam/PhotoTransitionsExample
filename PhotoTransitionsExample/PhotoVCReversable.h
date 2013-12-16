//
//  PhotoViewController2.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoVCReversable : UIViewController
<UIViewControllerTransitioningDelegate>
- (instancetype)initWithStartingFrame:(CGRect)startingFrame;
@end
