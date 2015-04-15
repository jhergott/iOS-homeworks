//
//  MasterViewController.h
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;


@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong,nonatomic) NSArray *dataSource;

- (void)refreshTable;

@end

