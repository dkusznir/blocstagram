//
//  MediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/31/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MediaFullScreenViewController.h"
#import "Media.h"
#import "ImagesTableViewController.h"

@interface MediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation MediaFullScreenViewController

- (instancetype) initWithMedia:(Media *)media
{
    self = [super init];
    
    if (self)
    {
        self.media = media;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.media.image.size;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2;
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    CGFloat getMaxX = (CGRectGetMaxX(self.view.frame) - 110);
    CGFloat getMinY = (CGRectGetMinY(self.view.frame) + 20);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(getMaxX, getMinY, 100, 50)];
    self.shareButton = button;
    [self.shareButton setTitle:NSLocalizedString(@"SHARE", @"Share") forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor colorWithRed:102/255.0 green:128/255.0 blue:153/255.0 alpha:1];
    self.shareButton.layer.cornerRadius = 10;
    self.shareButton.titleLabel.font = [UIFont fontWithName:@"Calibri-Bold" size:20];
    self.shareButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.shareButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.shareButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.shareButton];
}

- (void) buttonPressed:(UIButton *)sender
{
    [sender setAlpha:0.5];
}

- (void) buttonReleased:(UIButton *)sender
{
    [sender setAlpha:1.0];
    
    if (self.media.image)
    {
        [self didSelect:nil];
    }
}

- (void) didSelect:(UIImageView *)imageView
{
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (self.media.caption.length > 0)
    {
        [itemsToShare addObject:self.media.caption];
    }
    
    if (self.media.image)
    {
        [itemsToShare addObject:self.media.image];
    }
    
    if (itemsToShare > 0)
    {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
}

- (void)centerScrollView
{
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    }
    
    else
    {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    }
    
    else
    {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self centerScrollView];
}

#pragma mark - Gesture Recognizers

- (void) tapFired:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doubleTapFired:(UITapGestureRecognizer *)sender
{
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale)
    {
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.view.frame.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    }
    
    else
    {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
