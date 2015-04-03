//
//  ImagesTableViewController.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 3/18/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media, MediaTableViewCell;

@interface ImagesTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *mutableMediaItems;

@end
