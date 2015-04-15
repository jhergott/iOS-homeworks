//
//  MasterTableViewCell.h
//  Splitting
//
//  Created by Jake Hergott on 2/12/15.
//  Copyright (c) 2015 Jake Hergott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articleSnippet;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;

@end
