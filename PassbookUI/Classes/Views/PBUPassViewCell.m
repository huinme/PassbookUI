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

@property (nonatomic, strong, readwrite) UIView *contentView;

- (void)setup;

- (UIBezierPath *)roundPathWithSize:(CGSize)size
                       cornerRadius:(CGFloat)raidus;

@end

@implementation PBUPassViewCell

@synthesize contentView = _contentView;

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
    self.backgroundColor = [UIColor clearColor];

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGPathRef path = [self roundPathWithSize:self.bounds.size cornerRadius:8.0f].CGPath;

    // set shadow path
    self.layer.shadowPath = path;

    // draw content view
    if (self.contentView.superview != self) {
        [self addSubview:self.contentView];
    }
    self.contentView.frame = self.bounds;

    // clip content view with path
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.bounds;
    mask.path = path;
    self.contentView.layer.mask = mask;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
    }

    return _contentView;
}

- (UIBezierPath *)roundPathWithSize:(CGSize)size
                       cornerRadius:(CGFloat)radius
{
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, NULL, radius, 0.0f);
    CGPathAddLineToPoint(path, NULL, size.width-radius, 0.0f);

    CGPathAddArcToPoint(path, NULL,
                        size.width, 0.0f,
                        size.width, radius,
                        radius);

    CGPathAddLineToPoint(path, NULL, size.width, size.height-radius);

    CGPathAddArcToPoint(path, NULL,
                        size.width, size.height,
                        size.width-radius, size.height,
                        radius);

    CGPathAddLineToPoint(path, NULL, radius, size.height);

    CGPathAddArcToPoint(path, NULL,
                        0.0f, size.height, 0.0f,
                        size.height-radius,
                        radius);

    CGPathAddLineToPoint(path, NULL, 0.0f, radius);

    CGPathAddArcToPoint(path, NULL,
                        0.0f, 0.0f,
                        radius, 0.0f,
                        radius);

    CGPathCloseSubpath(path);

    UIBezierPath *beziePath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);

    return beziePath;
}

@end
