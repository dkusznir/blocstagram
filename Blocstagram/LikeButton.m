//
//  LikeButton.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 4/10/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "LikeButton.h"
#import "CircleSpinnerView.h"

#define kLikedStateImage @"heart-full"
#define kUnlikedStateImage @"heart-empty"

@interface LikeButton ()

@property (nonatomic, strong) CircleSpinnerView *spinnerView;

@end

@implementation LikeButton

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.spinnerView = [[CircleSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:self.spinnerView];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        self.likeButtonState = likeStateNotLiked;
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.spinnerView.frame = self.imageView.frame;
}

- (void)setLikeButtonState:(LikeState)likeButtonState
{
    _likeButtonState = likeButtonState;
    
    NSString *imageName;
    
    switch (_likeButtonState)
    {
        case likeStateLiked:
        case likeStateUnliking:
            imageName = kLikedStateImage;
            break;
            
        case likeStateNotLiked:
        case likeStateLiking:
            imageName = kUnlikedStateImage;
            break;
            
        default:
            break;
    }
    
    switch (_likeButtonState)
    {
        case likeStateLiking:
        case likeStateUnliking:
            self.spinnerView.hidden = NO;
            self.userInteractionEnabled = NO;
            break;
            
        case likeStateLiked:
        case likeStateNotLiked:
            self.spinnerView.hidden = YES;
            self.userInteractionEnabled = YES;
            
        default:
            break;
    }
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
