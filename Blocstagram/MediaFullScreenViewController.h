//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/31/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell, ImagesTableViewController;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) Media *media;

- (instancetype) initWithMedia:(Media *)media;
- (void) centerScrollView;
- (void) recalculateZoomScale;

@end
