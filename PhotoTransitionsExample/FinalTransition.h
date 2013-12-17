//
//  ScaleAndBlurTransition.h
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 12/12/2013.
//

#import <Foundation/Foundation.h>

@interface FinalTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithStartingFrame:(CGRect)startingFrame;

@property (assign, nonatomic) BOOL animateForegroundBackToStartingFrame;
@property (assign, nonatomic) BOOL reverse;
@property (strong, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveTransition;

@end
