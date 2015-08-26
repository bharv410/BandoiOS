//
//  GridViewController.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "GAITrackedViewController.h"

@interface GridViewController : GAITrackedViewController <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, retain) IBOutlet AQGridView * gridView;

@property (nonatomic, retain) NSMutableArray *bandoPosts;

@end