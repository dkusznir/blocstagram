//
//  ComposeCommentViewTests.m
//  Blocstagram
//
//  Created by Dorian Kusznir on 5/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposeCommentViewTests : XCTestCase

@end

@implementation ComposeCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsWritingCommentTrue
{
    NSString *sourceString = @"This is a string. We are testing the isWritingComment is true.";
    
    ComposeCommentView *testView = [[ComposeCommentView alloc] init];
    
    testView.text = sourceString;
    
    XCTAssertTrue(testView.isWritingComment, @"isWritingComment should be true");
}

- (void)testIsWritingCommentFalse
{
    NSString *sourceString = @"";
    
    ComposeCommentView *testView = [[ComposeCommentView alloc] init];
    
    testView.text = sourceString;
    
    XCTAssertFalse(testView.isWritingComment, @"isWritingComment should be false.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
