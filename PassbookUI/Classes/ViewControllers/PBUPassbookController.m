//
//  PBUPassbookController.m
//  PassbookUI
//
//  Created by huin on 2014/03/03.
//  Copyright (c) 2014年 huin.me. All rights reserved.
//

#import "PBUPassbookController.h"

#import "PBUPassListLayout.h"
#import "PBUPickedPassLayout.h"

#import "PBUPassViewCell.h"

@interface PBUPassbookController ()
<PBUPassViewCellDelegate,
 UICollectionViewDataSource,
 UICollectionViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) PBUPassListLayout *listLayout;
@property (nonatomic, strong, readwrite) PBUPickedPassLayout *pickedLayout;

- (void)updateCollectionViewWithLayout:(UICollectionViewLayout *)layout
                              animated:(BOOL)animated;

@end

@implementation PBUPassbookController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.collectionViewLayout = [[PBUPassListLayout alloc] init];
    self.collectionView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;

    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PBUPassViewCell class]) bundle:nil];
    [self.collectionView registerNib:nib
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

/// ----------------------------------------------------------------------------
#pragma mark - Privates
/// ----------------------------------------------------------------------------

- (void)updateCollectionViewWithLayout:(UICollectionViewLayout *)layout
                              animated:(BOOL)animated
                            completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.7f
                          delay:0.0f
         usingSpringWithDamping:3.0f
          initialSpringVelocity:0.01f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.collectionView setCollectionViewLayout:layout
                                                             animated:YES
                                                           completion:completion];
                     }
                     completion:nil];
}

/// ----------------------------------------------------------------------------
#pragma mark - Custom Accessors
/// ----------------------------------------------------------------------------

- (PBUPassListLayout *)listLayout
{
    if (!_listLayout) {
        _listLayout = [[PBUPassListLayout alloc] init];
    }
    return _listLayout;
}

- (PBUPickedPassLayout *)pickedLayout
{
    if (!_pickedLayout) {
        _pickedLayout = [[PBUPickedPassLayout alloc] init];
    }

    return _pickedLayout;
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

    cell.delegate = self;

    NSString *title = [NSString stringWithFormat:@"INDEX PATH : {%ld, %ld}", (long)indexPath.section, (long)indexPath.row];
    cell.titleLabel.text = title;

    id layout = self.collectionView.collectionViewLayout;
    if ([layout isKindOfClass:[PBUPickedPassLayout class]]) {
        cell.draggable = YES;
    }else{
        cell.draggable = NO;
    }

    return cell;
}

///-----------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
///-----------------------------------------------------------------------------

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    UICollectionViewLayout *layout;
    if (self.pickedLayout.selectedIndexPath) {
        NSLog(@"LAYOUT FOR LIST");
        self.pickedLayout.selectedIndexPath= nil;
        layout = self.listLayout;
    }else{
        NSLog(@"LAYOUT FOR PICKED");
        self.pickedLayout.selectedIndexPath= indexPath;
        layout = self.pickedLayout;
    }

    [self updateCollectionViewWithLayout:layout
                                animated:YES
                              completion:^(BOOL finished) {
                                  [self.collectionView reloadData];
                                  if (self.collectionView.collectionViewLayout == self.pickedLayout) {
                                      self.collectionView.scrollEnabled = NO;
                                  }else{
                                      self.collectionView.scrollEnabled = YES;
                                  }
                              }];
}

/// ----------------------------------------------------------------------------
#pragma mark - PBUPassViewCellDelegate
/// ----------------------------------------------------------------------------

- (void)passCellShouldDeselect:(PBUPassViewCell *)cell
{
    self.pickedLayout.selectedIndexPath = nil;
    [self updateCollectionViewWithLayout:self.listLayout
                                animated:YES
                              completion:^(BOOL finished) {
                                  [self.collectionView reloadData];
                                  self.collectionView.scrollEnabled = YES;
                              }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"offset : %@", NSStringFromCGPoint(scrollView.contentOffset));
}

@end
