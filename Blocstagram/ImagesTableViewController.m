//
//  ImagesTableViewController.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/18/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "ImagesTableViewController.h"
#import "User.h"
#import "Media.h"
#import "Comment.h"
#import "DataSource.h"
#import "MediaTableViewCell.h"
#import "MediaFullScreenAnimator.h"
#import "MediaFullScreenViewController.h"

@interface ImagesTableViewController () <MediaTableViewCellDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIImageView *lastTappedImageView;
@property (nonatomic, strong) Media *media;
@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation ImagesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    //NSMutableArray *media = [NSMutableArray arrayWithArray:[self items]];
    //self.mutableMediaItems = media;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[MediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
}

- (void) dealloc
{
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self items].count;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    NSLog(@"Visible Paths: %d", indexPaths.count);
    
    for (NSIndexPath *path in indexPaths)
    {
        Media *mediaItem = [[self items] objectAtIndex:path.row];
        
        if (mediaItem.downloadState == MediaDownloadStateNeedsImage)
        {
            [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
        }
    }
    */
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.decelerationRate = 100;
    
    if (scrollView.decelerating)
    {
        //NSArray *visibleCells = [self.tableView visibleCells];
        NSArray *indexPathsVisible = [self.tableView indexPathsForVisibleRows];
        NSMutableArray *mutableIndex = [indexPathsVisible mutableCopy];
        
        for (NSIndexPath *path in mutableIndex)
        {
            Media *mediaItem = [[self items] objectAtIndex:path.row];
            
            if (mediaItem.downloadState == MediaDownloadStateNeedsImage)
            {
                [[DataSource sharedInstance] downloadImageForMediaItem:mediaItem];
            }
        
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *item = [[self items] objectAtIndex:indexPath.row];
    
    return [MediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.mediaItem = [[self items] objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Return NO if you do not want the specified item to be editable.
    return YES;
}


- (NSArray *)items
{
    NSArray *media = [DataSource sharedInstance].mediaItems;
    
    return media;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"])
    {
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting)
        {
            [self.tableView reloadData];
        
        }
        
        else if (kindOfChange == NSKeyValueChangeInsertion || kindOfChange == NSKeyValueChangeRemoval || kindOfChange == NSKeyValueChangeReplacement)
        {
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            [self.tableView beginUpdates];
            
            if (kindOfChange == NSKeyValueChangeInsertion)
            {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            else if (kindOfChange == NSKeyValueChangeRemoval)
            {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            else if (kindOfChange == NSKeyValueChangeReplacement)
            {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [self.tableView endUpdates];
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        
        Media *item = [DataSource sharedInstance].mediaItems[indexPath.row];
        [[DataSource sharedInstance] deleteMediaItem:item];
        
        /*
         [tableView beginUpdates];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         [self.mutableMediaItems removeObjectAtIndex:indexPath.row];
         [tableView endUpdates];
         */
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
}

- (void) refreshControlDidFire:(UIRefreshControl *)sender
{
    [[DataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
}

- (void) infiniteScrollIfNecessary
{
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == (self.items.count - 1))
    {
        [[DataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    }
}


- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *item = [[self items] objectAtIndex:indexPath.row];
    
    if (item.image)
    {
        return 350;
    }
    
    else
    {
        return 150;
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self infiniteScrollIfNecessary];
    NSLog(@"Did call infiniteScroll");
}

#pragma mark - MediaTableViewCellDelegate

- (void) cell:(MediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView
{
    self.lastTappedImageView = imageView;
    
    MediaFullScreenViewController *fullScreenVC = [[MediaFullScreenViewController alloc] initWithMedia:cell.mediaItem];
    
    fullScreenVC.transitioningDelegate = self;
    fullScreenVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:fullScreenVC animated:YES completion:nil];
    
}

- (void) cell:(MediaTableViewCell *)cell didTwoTouchTap:(UIView *)cellContentView
{
    if (!cell.mediaItem.image)
    {
        [[DataSource sharedInstance] downloadImageForMediaItem:cell.mediaItem];
    }
}

- (void) cell:(MediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView
{
    
    NSArray *cellPropertiesToShare = [cell.mediaItem mediaPropertiesToShare:cell.mediaItem];
    
    if (cellPropertiesToShare.count > 0)
    {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:cellPropertiesToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    
    MediaFullScreenAnimator *animator = [MediaFullScreenAnimator new];
    animator.presenting = YES;
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    MediaFullScreenAnimator *animator = [MediaFullScreenAnimator new];
    animator.cellImageView = self.lastTappedImageView;
    return animator;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
