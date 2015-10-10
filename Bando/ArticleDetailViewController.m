//
//  ArticleDetailViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import <Google/Analytics.h>
#import <Parse/Parse.h>

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController{
    UIView *bottomBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Article Page";
    [self setupActionBar];
    
    //[self hideTheTabBarWithAnimation:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Article Page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    ///aboce i add the three nav bars
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    //UIImage *image = [self imageWithColor:greenColor];
    
    
    //[self getBackBtn];
    //UIView *topBar = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth, 50)];
    //[topBar setBackgroundColor:greenColor];
    
    
    //[self.view addSubview:topBar];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,50,screenWidth,screenHeight-90)];
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.websiteString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    
    self.navigationController.navigationBar.topItem.title = @"Bando";
    
//
    //[self addBackButtonWithTitle:@"Back"];
    
}

-(void)setupActionBar{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [customButton setImage:[UIImage imageNamed:@"itrending.png"] forState:UIControlStateNormal];
    [customButton setTitle:[self.viewCount stringValue] forState:UIControlStateNormal];
//    CGFloat spacing = 10; // the amount of spacing to appear between image and title
//    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
//    customButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    
    //customButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [customButton sizeToFit];
    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareAction:)];
    //    self.navigationItem.rightBarButtonItem = shareButton;
    // Create the refresh, fixed-space (optional), and profile buttons.
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNow)];
    
    //    // Optional: if you want to add space between the refresh & profile buttons
        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpaceBarButtonItem.width = 12;
    
    UIBarButtonItem *profileBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:self action:@selector(goToProfile)];
    profileBarButtonItem.style = UIBarButtonItemStyleBordered;
    
    self.navigationItem.rightBarButtonItems = @[ shareButton, refreshBarButtonItem,  fixedSpaceBarButtonItem,customBarButtonItem];

}

- (void)addBackButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)updateViewCountThreeViaParse{
    NSString *findBy = self.postString;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"VerifiedBandoPost"];
    [query1 orderByDescending:@"createdAt"];
    [query1 whereKey:@"postText" containsString:findBy];
    
    [query1 getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            // Found UserStats
           [userStats incrementKey:@"viewCount" byAmount:[NSNumber numberWithInt:1]];
            
            // Save
            [userStats saveInBackground];
            //show it on actionbar
            
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)shareAction:(id)sender
{
    NSLog(@"share action");
    [self share];
}

-(void)share{
    
    NSString *string = @"look what I found via @BandoTheApp";
    NSURL *URL = [NSURL URLWithString:self.websiteString];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                              NSLog(@"sharing");
                                          }];
}

-(void)saveNow{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.websiteString forKey:self.websiteString];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self backButtonPressed];
    
}

- (void) hideTheTabBarWithAnimation:(BOOL) withAnimation {
    if (NO == withAnimation) {
        [self.tabBarController.tabBar setHidden:YES];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDuration:0.75];
        
        [self.tabBarController.tabBar setAlpha:0.0];
        
        [UIView commitAnimations];
        //[self addGreenBar];
    }
}

- (void)addGreenBar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight-49-49, screenWidth, 49)];
    UIColor *greenColor = [self colorWithHexString:@"168807"];
    [bottomBar setBackgroundColor:greenColor];
    bottomBar.hidden = NO;
    [[[UIApplication sharedApplication] keyWindow] addSubview:bottomBar];

}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)backButtonPressed
{
//    bottomBar.hidden = YES;
//    [bottomBar removeFromSuperview];
    // write your code to prepare popview
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //To avoid link clicking.
    if(navigationType ==UIWebViewNavigationTypeLinkClicked)
        return  NO;
    
    //To avoid form submission.
    if(navigationType ==UIWebViewNavigationTypeFormSubmitted)
        return  NO;
    
    //To avoid loading all the google ads.
    if([request.URL.absoluteString rangeOfString:@"googleads"].location != NSNotFound)
        return NO;
    
    //return FALSE; //to stop loading
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self addGreenBar];
    [self updateViewCountThreeViaParse];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"Failed to load with error :%@",[error debugDescription]);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
