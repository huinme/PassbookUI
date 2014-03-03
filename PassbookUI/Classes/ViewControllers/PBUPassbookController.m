//
//  PBUPassbookController.m
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import "PBUPassbookController.h"

#import "PBUPassbookLayout.h"
#import "PBUPassViewCell.h"

@interface PBUPassbookController ()
<UICollectionViewDataSource,
 UICollectionViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet UICollectionView *collectionView;

@end

@implementation PBUPassbookController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.collectionViewLayout = [[PBUPassbookLayout alloc] init];
    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;

    [self.collectionView registerClass:[PBUPassViewCell class]
            forCellWithReuseIdentifier:[PBUPassViewCell reuseIdentifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///-----------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource
///-----------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PBUPassViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PBUPassViewCell reuseIdentifier]
                                                     forIndexPath:indexPath];

    cell.backgroundColor = [UIColor lightGrayColor];

    return cell;
}

///-----------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
///-----------------------------------------------------------------------------

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    NSLog(@"item at {%ld, %ld} was selected.", indexPath.section, indexPath.row);
}

@end
