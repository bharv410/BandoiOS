//
//  RootViewController.h
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import <Google/Analytics.h>

@interface RootViewController : GAITrackedViewController<UIGridViewDelegate, UISearchResultsUpdating> {
    NSArray *_bandoPosts;
}
@property (nonatomic, retain) IBOutlet UIGridView *table;
@property (strong, nonatomic) UISearchController *searchController;

@end
