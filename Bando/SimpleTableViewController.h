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
#import "YALSunnyRefreshControl.h"
#import "GAITrackedViewController.h"

@interface SimpleTableViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) STTwitterAPI *twitter;

@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak) InstagramEngine *instagramEngine;

@property (strong, nonatomic) NSMutableArray *bandoPosts;
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
-(void)editCategories;

@end