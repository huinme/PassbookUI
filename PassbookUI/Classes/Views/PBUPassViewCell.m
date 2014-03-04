//
//  PBUPassViewCell.m
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import "PBUPassViewCell.h"

static const CGFloat kCancellationThreshold = 100.0f;

@import QuartzCore;

@interface PBUPassViewCell()

@property (nonatomic, weak, readwrite) IBOutlet UIView *contentView;
@property (nonatomic, weak, readwrite) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign, readwrite) CGPoint revertPoint;

- (void)setup;
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture;
- (UIBezierPath *)roundPathWithSize:(CGSize)size
                       cornerRadius:(CGFloat)raidus;

- (void)cancelGestureToDeselection;
- (void)revertToPoint:(CGPoint)point
             animated:(BOOL)animated;

@end

@implementation PBUPassViewCell

@synthesize contentView = _contentView;
@synthesize titleLabel  = _titleLabel;

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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGPathRef path = [self roundPathWithSize:self.bounds.size cornerRadius:8.0f].CGPath;

    // set shadow path
    self.layer.shadowPath = path;

    // draw content view
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;

    // clip content view with path
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.bounds;
    mask.path = path;
    self.contentView.layer.mask = mask;
}

/// ----------------------------------------------------------------------------
#pragma mark - Custom Accessors
/// ----------------------------------------------------------------------------

- (void)setDraggable:(BOOL)draggable
{
    self.panGesture.enabled = draggable;
}

- (BOOL)isDraggable
{
    return self.panGesture.enabled;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePanGesture:)];
        _panGesture.enabled = YES;
        [self addGestureRecognizer:_panGesture];
    }
    
    return _panGesture;
}

/// ----------------------------------------------------------------------------
#pragma mark - Privtes
/// ----------------------------------------------------------------------------


- (void)setup
{
    self.backgroundColor = [UIColor clearColor];

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;

    self.draggable = NO;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    if (UIGestureRecognizerStateBegan == panGesture.state) {
        self.revertPoint = self.center;
    }else if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint touchPoint = [panGesture translationInView:self];
        CGPoint movedPoint = CGPointMake(self.center.x,
                                         self.center.y + touchPoint.y);

        self.center = movedPoint;
        [panGesture setTranslation:CGPointZero inView:self];
    }else{
        if (kCancellationThreshold < self.center.y - self.revertPoint.y) {
            [self cancelGestureToDeselection];
        }else{
            [self revertToPoint:self.revertPoint animated:YES];
        }
    }
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

- (void)cancelGestureToDeselection
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(passCellShouldDeselect:)]) {
        [self.delegate passCellShouldDeselect:self];
    }else{
        [self revertToPoint:self.revertPoint animated:YES];
    }
}

- (void)revertToPoint:(CGPoint)point
             animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.35f : 0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.center = point;
                     } completion:nil];
}
@end
