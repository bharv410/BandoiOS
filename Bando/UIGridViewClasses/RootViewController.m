//
//  RootViewController.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "BandoPost.h"
#import "Cell.h"
#import <Parse/Parse.h>
#import <Haneke/Haneke.h>
#import "ArticleDetailViewController.h"
#import "Reachability.h"
#import <Google/Analytics.h>
#import "SavedArticlesController.h"
#import <SKSplashView/SKSplashView.h>
#import <SKSplashView/SKSplashIcon.h>
#import "AppDelegate.h"
#import "NSDate+TimeAgo.h"

@implementation RootViewController{
    NSString *featuredPostLink;
    NSString *featuredPostString;
    NSNumber *featuedViewCount;
}


@synthesize table;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getOtherPosts];
    [self getFeaturedPost];
    
    SKSplashIcon *splashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"bandoheader.png"] animationType:SKIconAnimationTypeGrow];
    
    SKSplashView *splashView = [[SKSplashView alloc] initWithSplashIcon:splashIcon backgroundColor:[self colorWithHexString:@"168807"] animationType:SKSplashAnimationTypeNone];
    
    //The SplashView can be initialized with a variety of animation types and backgrounds. See customizability for more.
    splashView.animationDuration = 2.0f; //Set the animation duration (Default: 1s)
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window] addSubview:splashView]; //Add the splash view to your current view
    [splashView startAnimation]; //Call this method to start the splash animation
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Saved" style:UIBarButtonItemStylePlain target:self action:@selector(savedArticles)];
    
    self.screenName = @"Featured Page";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Featured Page"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    Reachability *netWorkReachablity = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [netWorkReachablity currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Internet Connection"
                              message:@"This app requires internet connection to work correctly"
                              delegate:self  // set nil if you don't want the yes button callback
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    self.navigationController.navigationBar.topItem.title = @"Bando";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, screenWidth, self.table.frame.size.height - CGRectGetHeight(self.tabBarController.tabBar.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame) + 22);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) setupSearchController : (UIView *)header{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"Current Articles",@"Country"),
//                                                          NSLocalizedString(@"All-time",@"Capital")];
    
    [self.searchController.searchBar setTintColor:[self colorWithHexString:@"166807"]];
    
    self.searchController.searchBar.delegate = self;
    [header addSubview:self.searchController.searchBar];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"sholda did something");
        [UIView animateWithDuration:0.5 animations:^{
            
            CGPoint contentOffset = self.table.contentOffset;
            //contentOffset.y += CGRectGetHeight(self.searchController.searchBar.frame);
            contentOffset.y += 22;
            self.table.contentOffset = contentOffset;
        
        }];
    });
}

-(void) getFeaturedPost{
    
    PFQuery *query = [PFQuery queryWithClassName:@"BandoFeaturedPost"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *object = [objects firstObject];
            BandoPost *bp = [[BandoPost alloc]init];
            bp.postLink = object[@"postLink"];
            bp.postType = @"article";
            bp.postText = object[@"text"];
            bp.createdAt = object.createdAt;
            bp.imageUrl = object[@"imageUrl"];
            bp.uniqueId = object.objectId;
            bp.viewCount = object[@"viewCount"];
            featuredPostLink = bp.postLink;
            featuredPostString = bp.postText;
            featuedViewCount = bp.viewCount;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth-20 +44)];
            
            
            NSString *url = bp.imageUrl;
            NSURL *imageURL = [[NSURL alloc]initWithString:url];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, screenWidth-20)];
            
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            
            [imageView hnk_setImageFromURL:imageURL];
            
            //            UIView *greenBG = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,(screenWidth- 40),imageView.frame.size.width,40)];
            //            greenBG.backgroundColor = [self colorWithHexString:@"166807"];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,(imageView.frame.size.height- 80 +44),imageView.frame.size.width,80)];
            headerLabel.text = bp.postText;
            headerLabel.textColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:24];
            headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerLabel.numberOfLines = 0;
            headerLabel.backgroundColor = [[self colorWithHexString:@"166807"]colorWithAlphaComponent:0.7f];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            
            
            [self setupSearchController:tableHeaderView];
            
            [tableHeaderView addSubview:imageView];
            //[tableHeaderView addSubview:greenBG];
            [tableHeaderView addSubview:headerLabel];
            
            [self setupSearchController:tableHeaderView];
            
            self.table.tableHeaderView = tableHeaderView;
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            [self.table.tableHeaderView addGestureRecognizer:singleFingerTap];
        }
    }];
    
    //[self addHeader];
}

-(void)getOtherPosts{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"VerifiedBandoPost"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:24];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray * allImageNames = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = object[@"postLink"];
                bp.postType = @"article";
                bp.postText = object[@"postText"];
                bp.createdAt = object.createdAt;
                bp.imageUrl = object[@"imageUrl"];
                bp.uniqueId = object.objectId;
                bp.viewCount = object[@"viewCount"];
                [allImageNames addObject:bp];
            }
            _bandoPosts = [allImageNames copy];
            [self.table reloadData];
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    //[super dealloc];
}


- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
	return screenWidth/2;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
	return screenWidth/2 + 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 2;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if(self.searchController.active){
        return [_searchreturndbandoPosts count];
    }else{
        return [_bandoPosts count];
    }
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[Cell alloc] init];
	}
    
    if(self.searchController.active){
        BandoPost *currentPost = [_searchreturndbandoPosts objectAtIndex:rowIndex*2+columnIndex];
        if(currentPost!=nil){
            cell.label.text = currentPost.postText;
            [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:currentPost.imageUrl]];
            cell.timeStampLabel.text = [currentPost.createdAt timeAgo];
        }
    }else{
        BandoPost *currentPost = [_bandoPosts objectAtIndex:rowIndex*2+columnIndex];
        if(currentPost!=nil){
            cell.label.text = currentPost.postText;
            [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:currentPost.imageUrl]];
            cell.timeStampLabel.text = [currentPost.createdAt timeAgo];
        }
    }
    CGSize textSize = [[cell.timeStampLabel text] sizeWithAttributes:@{NSFontAttributeName:[cell.timeStampLabel font]}];
    
    //CGFloat strikeWidth = textSize.width;
    CGFloat strikeWidth = cell.thumbnail.frame.size.width;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.timeStampLabel.frame.origin.y+19, strikeWidth, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [cell.view addSubview:lineView];
	
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
	NSLog(@"%d, %d clicked", rowIndex, colIndex);
    if(self.searchController.active){
        BandoPost *currentPost = [_searchreturndbandoPosts objectAtIndex:rowIndex*2+colIndex];
        NSString *siteUrl = currentPost.postLink;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = siteUrl;
        articleDetail.postString = currentPost.postText;
        articleDetail.viewCount = currentPost.viewCount;
        [self.navigationController pushViewController:articleDetail animated:YES];
    }else{
    //[self.gridView deselectItemAtIndex:index animated:YES];
    BandoPost *currentPost = [_bandoPosts objectAtIndex:rowIndex*2+colIndex];
    NSString *siteUrl = currentPost.postLink;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
    articleDetail.websiteString = siteUrl;
        articleDetail.viewCount = currentPost.viewCount;
    articleDetail.postString = currentPost.postText;
    [self.navigationController pushViewController:articleDetail animated:YES];
    }
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

-(void)savedArticles{
    NSLog(@"Saved");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SavedArticlesController *articleDetail = (SavedArticlesController *)[storyboard instantiateViewControllerWithIdentifier:@"savedArticles"];
    //articleDetail.websiteString = siteUrl;
    
    [self.navigationController pushViewController:articleDetail animated:YES];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if(featuredPostLink!=nil){
        NSString *siteUrl = featuredPostLink;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = siteUrl;
        articleDetail.postString = featuredPostString;
        articleDetail.viewCount = featuedViewCount;
        [self.navigationController pushViewController:articleDetail animated:YES];
    }
    //Do stuff here...
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
}

- (void)searchForText:(NSString *)searchText scope:(NSInteger)scopeOption
{
[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.table.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.searchController.searchBar becomeFirstResponder];
    
    if(self.searchController.active)
        NSLog(@"is active");
    PFQuery *query1 = [PFQuery queryWithClassName:@"VerifiedBandoPost"];
    [query1 orderByDescending:@"createdAt"];
    [query1 whereKey:@"postText" containsString:searchText];
    
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray * allImageNames = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = object[@"postLink"];
                bp.postType = @"article";
                bp.postText = object[@"postText"];
                bp.createdAt = object.createdAt;
                bp.imageUrl = object[@"imageUrl"];
                bp.uniqueId = object.objectId;
                bp.viewCount = object[@"viewCount"];
                [allImageNames addObject:bp];
                NSLog(@" text = %@",bp.postText);
            }
            _searchreturndbandoPosts = [allImageNames copy];
            [self.table reloadData];
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
        NSLog(@"is NOT active");

    [self getFeaturedPost];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)didDismissSearchController:(UISearchController *)arg1{
    NSLog(@"bam");
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)didPresentSearchController:(UISearchController *)arg1{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


@end
