//
//  MediaFullScreenViewController.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/31/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell, ImagesTableViewController;

@protocol MediaFullScreenDelegate <NSObject>

- (void) didSelectMedia:(Media *)media;

@end

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id <MediaFullScreenDelegate> delegate;

- (instancetype) initWithMedia:(Media *)media;
- (void) centerScrollView;

@end
