//
//  CameraViewController.h
//  Blocstagram
//
//  Created by Dorian Kusznir on 4/22/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "ViewController.h"

@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>

- (void) cameraViewController:(CameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image;

@end

@interface CameraViewController : ViewController

@property (nonatomic, weak) NSObject <CameraViewControllerDelegate> *delegate;

@end
