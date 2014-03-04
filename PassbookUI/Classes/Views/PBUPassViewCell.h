//
//  PBUPassViewCell.h
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBUPassViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) IBOutlet UIView *contentView;
@property (nonatomic, weak, readonly) IBOutlet UILabel *titleLabel;

+ (NSString *)reuseIdentifier;

@end
