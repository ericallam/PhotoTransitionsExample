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
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
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
    
    self.photoView.image = self.image;
    
    if (self.modalPresentationStyle == UIModalPresentationCustom) {
        [self configureViewForCustomPresentation];
    }
}

- (void)configureViewForCustomPresentation
{
    self.view.backgroundColor = [UIColor clearColor];
}
@end
