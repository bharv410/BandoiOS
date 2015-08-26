//
//  ArticleDetailViewController.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface ArticleDetailViewController : GAITrackedViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *websiteString;
@property (strong, nonatomic) IBOutlet UINavigationItem *navTitle;

@end
