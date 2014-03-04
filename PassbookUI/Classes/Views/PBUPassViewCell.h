//
//  PBUPassViewCell.h
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBUPassViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *contentView;


+ (NSString *)reuseIdentifier;

@end
