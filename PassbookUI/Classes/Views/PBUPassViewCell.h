//
//  PBUPassViewCell.h
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBUPassViewCell;

@protocol PBUPassViewCellDelegate <NSObject>

- (void)passCellShouldDeselect:(PBUPassViewCell *)cell;

@end


@interface PBUPassViewCell : UICollectionViewCell

@property (nonatomic, weak, readwrite) id<PBUPassViewCellDelegate> delegate;

@property (nonatomic, weak, readonly) IBOutlet UIView *contentView;
@property (nonatomic, weak, readonly) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign, readwrite, getter = isDraggable) BOOL draggable;

+ (NSString *)reuseIdentifier;

@end
