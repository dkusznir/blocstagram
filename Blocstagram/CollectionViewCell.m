//
//  CollectionViewCell.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 5/3/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    self = [super init];
    static NSInteger imageViewTag = 1000;
    static NSInteger labelTag = 1001;
    
    self.thumbnail = [[UIImageView alloc] init];
    self.label = [[UILabel alloc] init];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;

    CGFloat thumbnailEdgeSize = flowLayout.itemSize.width;
    
    if (!self.thumbnail)
    {
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbnailEdgeSize, thumbnailEdgeSize)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.tag = imageViewTag;

        [self.contentView addSubview:self.thumbnail];
    }
    
    if (!self.label)
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, thumbnailEdgeSize, thumbnailEdgeSize, 20)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
        self.label.tag = labelTag;
        
        [self.contentView addSubview:self.label];
    }
    
    return self;

}

@end
