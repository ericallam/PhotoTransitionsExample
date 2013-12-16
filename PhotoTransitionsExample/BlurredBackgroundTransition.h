//
//  BlurredBackgroundTransition.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 15/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlurredBackgroundTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) CGRect startingFrame;
@property (assign, atomic) NSTimeInterval duration;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> context;

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;

@end
