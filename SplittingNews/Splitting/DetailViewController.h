//
//  DetailViewController.h
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkViewController.h"
#import "MasterViewController.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate, UIWebViewDelegate,UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) id detailItem;

@end

