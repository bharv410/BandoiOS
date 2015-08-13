//
//  SimpleTableViewController.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STTwitter/STTwitter.h>
#import <InstagramKit/InstagramKit.h>

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) STTwitterAPI *twitter;
@property (strong, nonatomic) NSMutableArray *twitPosts;

@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak) InstagramEngine *instagramEngine;

@end