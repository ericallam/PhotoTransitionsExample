//
//  PhotoViewController.m
//  PhotoTransitionsExample
//
//  Created by Eric Allam on 10/12/2013.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (weak, nonatomic) UIImage *image;
@end

@implementation PhotoViewController

- (instancetype)initWithImage:(UIImage *)image;
{
    if (self = [super init]) {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIImageView alloc] initWithImage:self.image];
    
    CGFloat ratio = CGRectGetHeight(self.view.frame) / CGRectGetWidth(self.view.frame);
    
    self.view.frame = CGRectMake(0, 0, 320, 320*ratio);
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    self.view.userInteractionEnabled = YES;
}
@end
