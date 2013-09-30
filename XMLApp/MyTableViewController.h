//
//  MyTableViewController.h
//  XMLApp
//
//  Created by Vikash Soni on 20/09/13.
//  Copyright (c) 2013 Vikash Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewController : UITableViewController<NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
