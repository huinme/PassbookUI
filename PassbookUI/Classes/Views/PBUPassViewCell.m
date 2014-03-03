//
//  PBUPassViewCell.m
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import "PBUPassViewCell.h"

@import QuartzCore;

@interface PBUPassViewCell()

- (void)setup;

@end

@implementation PBUPassViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor redColor];

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 7.5f;

    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    self.layer.shadowRadius = 1.0f;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

@end
