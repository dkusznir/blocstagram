//
//  MediaTableViewCell.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/20/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "MediaTableViewCell.h"
#import "Media.h"
#import "Comment.h"
#import "User.h"
#import "LikeButton.h"
#import "ComposeCommentView.h"

@interface MediaTableViewCell () <UIGestureRecognizerDelegate, ComposeCommentViewDelegate>

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *usernameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *twoTapGestureRecognizer;
@property (nonatomic, strong) LikeButton *likeButton;
@property (nonatomic, strong) UILabel *numberOfLikes;
@property (nonatomic, strong) ComposeCommentView *commentView;

@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation MediaTableViewCell

+ (void)load
{
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
    commentLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1]; /*#58506d*/
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
    
}

+ (CGFloat)heightForMediaItem:(Media *)mediaItem width:(CGFloat)width
{
    MediaTableViewCell *layoutCell = [[MediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    layoutCell.mediaItem = mediaItem;
    
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    return CGRectGetMaxY(layoutCell.commentView.frame);
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.mediaImageView = [[UIImageView alloc] init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.twoTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapFired:)];
        [self.twoTapGestureRecognizer setNumberOfTouchesRequired:2];
        self.twoTapGestureRecognizer.delegate = self;
        [self.contentView addGestureRecognizer:self.twoTapGestureRecognizer];
        
        self.usernameAndCaptionLabel = [[UILabel alloc] init];
        self.usernameAndCaptionLabel.numberOfLines = 0;
        self.usernameAndCaptionLabel.backgroundColor = usernameLabelGray;
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = commentLabelGray;
        
        self.likeButton = [[LikeButton alloc] init];
        [self.likeButton addTarget:self action:@selector(likePressed:) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.backgroundColor = usernameLabelGray;
        
        self.numberOfLikes = [[UILabel alloc] init];
        self.numberOfLikes.font = [UIFont fontWithName:@"Calibri-Bold" size:8];
        self.numberOfLikes.backgroundColor = usernameLabelGray;
        
        self.commentView = [[ComposeCommentView alloc] init];
        self.commentView.delegate = self;

        
        for (UIView *view in @[self.mediaImageView, self.usernameAndCaptionLabel, self.commentLabel, self.likeButton, self.numberOfLikes, self.commentView])
        {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [self createConstraints];
    
    }
    
    return self;
}

- (void) longPressFired:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate cell:self didLongPressImageView:self.mediaImageView];
    }
}

- (void) twoTapFired:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [self.delegate cell:self didTwoTouchTap:self.contentView];
    }
}

- (NSAttributedString *)userNameAndCaptionString
{
    CGFloat usernameFontSize = 15;
    
    NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
    
    NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];

    NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
    [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
    [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
    
    
    return mutableUsernameAndCaptionString;
    
    return nil;
}

- (NSAttributedString *)commentString
{
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    
    for (Comment *comment in self.mediaItem.comments)
    {
        NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName, comment.text];
        
        NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
        [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
        [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
        
        [commentString appendAttributedString:oneCommentString];
    }
    
    return commentString;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
    CGSize usernameLabelSize = [self.usernameAndCaptionLabel sizeThatFits:maxSize];
    CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
    
    self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height + 20;
    self.commentLabelHeightConstraint.constant = commentLabelSize.height + 20;
    
    if (_mediaItem.image)
    {
        if (isPhone)
        {
            self.imageHeightConstraint.constant = ((self.mediaItem.image.size.height / self.mediaItem.image.size.width) * CGRectGetWidth(self.contentView.bounds));
        }
        
        else
        {
            self.imageHeightConstraint.constant = 320;
        }
    }
    
    else
    {
        self.imageHeightConstraint.constant = (CGRectGetHeight(self.contentView.bounds) / 2);
    }

    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
    
}


- (NSString *)updateNumberOfLikes:(Media *)mediaItem
{
    NSString *numberOfLikesToString = [NSString stringWithFormat:@"%lu", (unsigned long)self.mediaItem.numberOfLikes];
    self.numberOfLikes.text = numberOfLikesToString;
    
    return self.numberOfLikes.text;
}

- (void)setMediaItem:(Media *)mediaItem
{
    _mediaItem = mediaItem;
    self.mediaImageView.image = _mediaItem.image;
    self.usernameAndCaptionLabel.attributedText = [self userNameAndCaptionString];
    self.commentLabel.attributedText = [self commentString];
    self.likeButton.likeButtonState = _mediaItem.likeState;
    self.numberOfLikes.text = [NSString stringWithFormat:@"%lu", (unsigned long)_mediaItem.numberOfLikes];
    self.commentView.text = mediaItem.temporaryComment;
}

#pragma mark - Liking
- (void) likePressed:(UIButton *)sender
{
    [self.delegate cellDidPressLikeButton:self forLabel:self.likeButton];
    [self updateNumberOfLikes:self.mediaItem];
    NSLog(@"%ld", (unsigned long)self.likeButton.likeButtonState);

}

#pragma mark - Image View

- (void) tapFired:(UITapGestureRecognizer *)sender
{
    [self.delegate cell:self didTapImageView:self.mediaImageView];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.isEditing == NO;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:NO animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

#pragma mark - ComposeCommentViewDelegate

- (void) commentViewDidPressCommentButton:(ComposeCommentView *)sender
{
    [self.delegate cell:self didComposeComment:self.mediaItem.temporaryComment];
}

- (void) commentView:(ComposeCommentView *)sender textDidChange:(NSString *)text
{
    self.mediaItem.temporaryComment = text;
}

- (void) commentViewWillStartEditing:(ComposeCommentView *)sender
{
    [self.delegate cellWillStartComposingComment:self];
}

- (void) stopComposingComment
{
    [self.commentView stopComposingComment];
}

#pragma mark - iPad

- (void)createConstraints
{
    if (isPhone)
    {
        [self createPhoneConstraints];
    }
    
    else
    {
        [self createPadConstraints];
    }
    
    [self createCommonConstraints];
}

- (void)createPadConstraints
{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _likeButton, _commentView);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_mediaImageView(360)]" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:0
                                                                toItem:_mediaImageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
}

- (void)createPhoneConstraints
{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _likeButton, _commentView);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    
}

- (void)createCommonConstraints
{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _usernameAndCaptionLabel, _commentLabel, _likeButton, _numberOfLikes, _commentView);
    
    if (isPhone)
    {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_usernameAndCaptionLabel][_numberOfLikes][_likeButton(==38)]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentView]|" options:kNilOptions metrics:nil views:viewDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_usernameAndCaptionLabel][_commentLabel][_commentView(==100)]" options:kNilOptions metrics:nil views:viewDictionary]];
    
    self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_usernameAndCaptionLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
    
    [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint]];
    
}

@end
