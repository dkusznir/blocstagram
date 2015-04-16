//
//  MediaTableViewCell.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell, LikeButton;

@protocol MediaTableViewCellDelegate <NSObject>

- (void) cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void) cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)cellContentView;
- (void) cell:(MediaTableViewCell *)cell didTwoTouchTap:(UIView *)imageView;
- (void) cellDidPressLikeButton:(MediaTableViewCell *)cell;
//- (void) cellGetNumberOfLikes:(MediaTableViewCell *)cell;

@end

@interface MediaTableViewCell : UITableViewCell

@property (nonatomic, strong) Media *mediaItem;
@property (nonatomic, weak) id <MediaTableViewCellDelegate> delegate;

+ (CGFloat) heightForMediaItem:(Media *)mediaItem width:(CGFloat)width;

@end
