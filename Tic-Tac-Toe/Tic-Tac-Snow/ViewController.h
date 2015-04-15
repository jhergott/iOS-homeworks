//
//  ViewController.h
//  Tic-Tac-Snow
//
//  Created by Jake Hergott on 2/4/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSArray *squares;
@property (strong,nonatomic) NSMutableArray *squaresFilled;

- (IBAction)panGesture:(id)sender;

- (void)checkGameStatus;
- (void)addCubsImage;
- (void)addSoxImage;

@end

