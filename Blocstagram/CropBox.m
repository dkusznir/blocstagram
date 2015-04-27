//
//  CropBox.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 4/24/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "CropBox.h"

@interface CropBox ()

@property (nonatomic, strong) NSArray *horizontalLines;
@property (nonatomic, strong) NSArray *verticalLines;
@property (nonatomic, strong) UIToolbar *topView;
@property (nonatomic, strong) UIToolbar *bottomView;

@end

@implementation CropBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.userInteractionEnabled = NO;
        
        [self createToolbars];
        
        NSArray *lines = [self.horizontalLines arrayByAddingObjectsFromArray:self.verticalLines];
        
        for (UIView *lineView in lines)
        {
            [self addSubview:lineView];
        }
        
    }
    
    return self;
}

- (void)createToolbars
{
    self.topView = [UIToolbar new];
    self.bottomView = [UIToolbar new];
    
    UIColor *whiteBG = [UIColor colorWithWhite:1.0 alpha:0.15];
    self.topView.barTintColor = whiteBG;
    self.bottomView.barTintColor = whiteBG;
    
    self.topView.alpha = 0.5;
    self.bottomView.alpha = 0.5;
    
}

- (NSArray *)horizontalLines
{
    if (!_horizontalLines)
    {
        _horizontalLines = [self newArrayOfFourWhiteViews];
    }
    
    return _horizontalLines;
}

- (NSArray *)verticalLines
{
    if (!_verticalLines)
    {
        _verticalLines = [self newArrayOfFourWhiteViews];
    }
    
    return _verticalLines;
}

- (NSArray *)newArrayOfFourWhiteViews
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++)
    {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [array addObject:view];
    }
    
    return array;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat thirdOfWidth = width / 3;
    
    for (int i = 0; i < 4; i++)
    {
        UIView *horizontalLine = self.horizontalLines[i];
        UIView *verticalLine = self.verticalLines[i];
        
        horizontalLine.frame = CGRectMake(0, (i * thirdOfWidth), width, 0.5);
        
        CGRect verticalFrame = CGRectMake((i * thirdOfWidth), 0, 0.5, width);

        if (i == 3)
        {
            verticalFrame.origin.x -= 0.5;
        }
        
        verticalLine.frame = verticalFrame;
    }
    
    
}

@end
