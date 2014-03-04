//
//  PBUPickedPassLayout.m
//  PassbookUI
//
//  Created by Koichi Sakata on 3/4/14.
//  Copyright (c) 2014 huin.me. All rights reserved.
//

#import "PBUPickedPassLayout.h"

static const CGFloat kFrontPassHeight = 58.0f;

@interface PBUPickedPassLayout()

@end

@implementation PBUPickedPassLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndexPath = nil;
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
    UIEdgeInsets inset = self.collectionView.contentInset;
    size.height -= (inset.top + inset.bottom - 1.0);

    return size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];

    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int idx = 0; idx < items; ++idx) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        UICollectionViewLayoutAttributes *attribute;
        attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attribute];
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger items = [self.collectionView numberOfItemsInSection:indexPath.section];

    UICollectionViewLayoutAttributes *attributes;
    attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat hPadding = 2.0f;
    // size
    attributes.size = CGSizeMake(CGRectGetWidth(self.collectionView.bounds) - hPadding,
                                 450.0f);

    // frame
    CGRect frame = CGRectZero;
    frame.origin.x = hPadding/2;

    if (self.selectedIndexPath &&
        NSOrderedSame == [indexPath compare:self.selectedIndexPath]) {
        // SELECTED : one
        frame.origin.y = 10.0f;
    }else{
        // SELECTED : others
        frame.origin.y = [self collectionViewContentSize].height - kFrontPassHeight;

        // そのままだと選択されたセル分大きく隙間が空くので、
        // 選択されたindexPathより奥にある(= rowが小さい)ものは
        // 1段階手前に持ってくる(= rowを大きくする)
        NSInteger rowOffset = (self.selectedIndexPath.row > indexPath.row) ? indexPath.row + 1 : indexPath.row;
        frame.origin.y -= 5.0f * (items - rowOffset);
    }

    frame.size = attributes.size;
    attributes.frame = frame;

    // bounds
    attributes.bounds = CGRectMake(0.0f, 0.0f, attributes.size.width, attributes.size.height);

    // alpha
    attributes.alpha = 1.0f;

    // z-index
    attributes.zIndex = indexPath.row;
    
    return attributes;
}

@end
