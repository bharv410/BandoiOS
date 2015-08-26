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


@implementation RootViewController{
    NSString *featuredPostLink;
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

    self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, screenWidth, self.table.frame.size.height - CGRectGetHeight(self.tabBarController.tabBar.frame));
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) getFeaturedPost{
    
    PFQuery *query = [PFQuery queryWithClassName:@"BandoFeaturedPost"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *object = [objects firstObject];
            BandoPost *bp = [[BandoPost alloc]init];
            bp.postLink = object[@"postLink"];
            featuredPostLink = bp.postLink;
            bp.postType = @"article";
            bp.postText = object[@"text"];
            bp.createdAt = object.createdAt;
            bp.imageUrl = object[@"imageUrl"];
            bp.uniqueId = object.objectId;
            bp.viewCount = object[@"viewCount"];
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth-20)];
            
            
            NSString *url = bp.imageUrl;
            NSURL *imageURL = [[NSURL alloc]initWithString:url];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, screenWidth-20, screenWidth-20)];
            
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            
            [imageView hnk_setImageFromURL:imageURL];
            
            //            UIView *greenBG = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,(screenWidth- 40),imageView.frame.size.width,40)];
            //            greenBG.backgroundColor = [self colorWithHexString:@"166807"];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x,(imageView.frame.size.height- 80),imageView.frame.size.width,80)];
            headerLabel.text = bp.postText;
            headerLabel.textColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:24];
            headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerLabel.numberOfLines = 0;
            headerLabel.backgroundColor = [[self colorWithHexString:@"166807"]colorWithAlphaComponent:0.7f];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            
            [tableHeaderView addSubview:imageView];
            //[tableHeaderView addSubview:greenBG];
            [tableHeaderView addSubview:headerLabel];
            
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
	return screenWidth/2 + 60;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 2;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
	return [_bandoPosts count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
	Cell *cell = (Cell *)[grid dequeueReusableCell];
	
	if (cell == nil) {
		cell = [[Cell alloc] init];
	}
    
    
    BandoPost *currentPost = [_bandoPosts objectAtIndex:rowIndex*2+columnIndex];
    if(currentPost!=nil){
	cell.label.text = currentPost.postText;
    [cell.thumbnail hnk_setImageFromURL:[NSURL URLWithString:currentPost.imageUrl]];
    }
	
	return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
	NSLog(@"%d, %d clicked", rowIndex, colIndex);
    //[self.gridView deselectItemAtIndex:index animated:YES];
    BandoPost *currentPost = [_bandoPosts objectAtIndex:rowIndex*2+colIndex];
    NSString *siteUrl = currentPost.postLink;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
    articleDetail.websiteString = siteUrl;
    [self.navigationController pushViewController:articleDetail animated:YES];
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

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if(featuredPostLink!=nil){
        NSString *siteUrl = featuredPostLink;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = siteUrl;
        [self.navigationController pushViewController:articleDetail animated:YES];
    }
    //Do stuff here...
}


@end
