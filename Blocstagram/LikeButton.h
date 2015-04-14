//
//  LikeButton.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 4/10/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LikeState)
{
    likeStateNotLiked = 0,
    likeStateLiking = 1,
    likeStateLiked = 2,
    likeStateUnliking = 3
};

@interface LikeButton : UIButton

@property (nonatomic, assign) LikeState likeButtonState;

@end
