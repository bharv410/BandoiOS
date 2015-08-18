//
//  SimpleTableViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "ListViewCell.h"
#import <InstagramKit/InstagramKit.h>
#import "BandoPost.h"
#import <Haneke/Haneke.h>
#import "ChooseCategoriesViewController.h"
#import "YALSunnyRefreshControl.h"
#import "ArticleDetailViewController.h"

NSString * const TWITTER_CONSUMER_KEY = @"QAM6jdb170hyMhJmMwoqbjRCg";
NSString * const TWITTER_CONSUMER_SECRET = @"X70RAkYKUDtJH4Hpg5CizyvkJ7zZvrTFbAtOEjLkFQmoSdQ87i";

@interface SimpleTableViewController (){
    NSArray *photoArray;
    NSArray *nameArray;
    NSArray *descriptionArray;
    NSArray *cardSizeArray;
    NSUserDefaults *userDefaults;
    BOOL twitSet;
    }

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize table dat
    userDefaults = [NSUserDefaults standardUserDefaults];
    twitSet = NO;
    [self setupRefreshControl];
    
    
    self.navigationController.navigationBar.topItem.title = @"Bando";


    self.myTableView.separatorColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]; //%%% This is so if you overscroll, the color is still gray

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, screenWidth, self.myTableView.frame.size.height);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editCategories)];
    
    [self getTwitPosts];
}

- (void)viewDidAppear:(BOOL)animated{
    self.instagramEngine = [InstagramEngine sharedEngine];
    [self.bandoPosts removeAllObjects];
    self.bandoPosts = [[NSMutableArray alloc]init];

    [self grabAcceptableTwits];
}

-(void)editCategories{
    ChooseCategoriesViewController *ccvc = [[ChooseCategoriesViewController alloc]init];
    [self.navigationController pushViewController:ccvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BandoPost *thisPost = [self.bandoPosts objectAtIndex:indexPath.row];
    if([thisPost.postType isEqualToString:@"instagram"]){
        return [((NSNumber*)@250)intValue];
    }else{
    return [((NSNumber*)@200)intValue];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([self.bandoPosts count]>0)
        return [self.bandoPosts count];
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BandoPost *bp = [self.bandoPosts objectAtIndex:indexPath.row];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:bp.postDeepLink]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bp.postDeepLink]];
    }else{
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:bp.postLink]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = bp.postLink;
        [self.navigationController pushViewController:articleDetail animated:YES];
        
    }
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)getMusicTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"Hot97",@"Kendricklamar",@"drake",@"metroboomin",@"applemusic",@"1future", nil];
    
    for(NSString *username in twitUsers){
        [self.twitter getUserTimelineWithScreenName:username
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           for(NSDictionary *cur in statuses){
                                               BandoPost *bp = [[BandoPost alloc]init];
                                               bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                               bp.postType = @"twitter";
                                               bp.uniqueId = [cur valueForKey:@"id"];
                                               bp.postDeepLink = [NSString stringWithFormat:@"twitter://status?id=%@",bp.uniqueId];
                                               bp.postLink = [NSString stringWithFormat:@"http://twitter.com/%@/statuses/%@",
                                                              bp.username,bp.uniqueId];
                                               bp.postText = [cur valueForKey:@"text"];
                                               bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                               if(![self.bandoPosts containsObject:bp])
                                                   [self.bandoPosts addObject:bp];
                                           }
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                       }];
    }
    
    
}

-(void)getSportsTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"KingJames",@"kobebryant",@"kdtrey5",@"Chris_Broussard",@"NikeBasketball",@"uabasketball",@"RealSkipBayless", @"stephenasmith", nil];

        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:2
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.uniqueId = [cur valueForKey:@"id"];
                                                   bp.postDeepLink = [NSString stringWithFormat:@"twitter://status?id=%@",bp.uniqueId];
                                                   bp.postLink = [NSString stringWithFormat:@"http://twitter.com/%@/statuses/%@",
                                                                  bp.username,bp.uniqueId];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   if(![self.bandoPosts containsObject:bp])
                                                       [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)getSportsIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"16264572",@"19410587",@"13864937",nil];
    
    for(NSString *username in igUsers){
        [self.instagramEngine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                NSString *deepLink = [NSString stringWithFormat:@"instagram://media?id=%@",cur.Id];
                bp.postDeepLink = deepLink;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)getArtIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"143795932",@"176915912",@"13613836",@"787132",nil];
    
    for(NSString *username in igUsers){
        [self.instagramEngine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                NSString *deepLink = [NSString stringWithFormat:@"instagram://media?id=%@",cur.Id];
                bp.postDeepLink = deepLink;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)getMusicIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"14455831",@"6720655",@"25945306",@"18900337"
                        ,@"266319242",@"10685362",@"18900337",nil];
    
    for(NSString *username in igUsers){
        [self.instagramEngine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                NSString *deepLink = [NSString stringWithFormat:@"instagram://media?id=%@",cur.Id];
                bp.postDeepLink = deepLink;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)getComedyIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"1535836050",@"10245461",@"6590609",@"15209885",nil];
    
    for(NSString *username in igUsers){
        [self.instagramEngine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                NSString *deepLink = [NSString stringWithFormat:@"instagram://media?id=%@",cur.Id];
                bp.postDeepLink = deepLink;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)getCultureIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"6380930",@"174247675",@"12281817",@"28011380",nil];
    
    for(NSString *username in igUsers){
        [self.instagramEngine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                NSString *deepLink = [NSString stringWithFormat:@"instagram://media?id=%@",cur.Id];
                bp.postDeepLink = deepLink;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
            [self.myTableView reloadData];
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)getCultureTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"nicekicks",@"kyliejenner", nil];
    
        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:2
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.uniqueId = [cur valueForKey:@"id"];
                                                   bp.postDeepLink = [NSString stringWithFormat:@"twitter://status?id=%@",bp.uniqueId];
                                                   bp.postLink = [NSString stringWithFormat:@"http://twitter.com/%@/statuses/%@",
                                                                  bp.username,bp.uniqueId];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)getComedyTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"desusnice",@"dahoodvines",@"lilduval", nil];
    
    
    
        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:2
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.uniqueId = [cur valueForKey:@"id"];
                                                   bp.postDeepLink = [NSString stringWithFormat:@"twitter://status?id=%@",bp.uniqueId];
                                                   bp.postLink = [NSString stringWithFormat:@"http://twitter.com/%@/statuses/%@",
                                                                  bp.username,bp.uniqueId];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)shuffleArray{
    NSUInteger count = [self.bandoPosts count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.bandoPosts exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

-(void)getArtTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"Streetartnews",@"History_Pics", nil];

    
        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:2
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.uniqueId = [cur valueForKey:@"id"];
                                                   bp.postDeepLink = [NSString stringWithFormat:@"twitter://status?id=%@",bp.uniqueId];
                                                   bp.postLink = [NSString stringWithFormat:@"http://twitter.com/%@/statuses/%@",
                                                                  bp.username,bp.uniqueId];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)getTwitPosts{
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                   consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        twitSet = YES;
        [self grabAcceptableTwits];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)grabAcceptableTwits{
        if([userDefaults boolForKey:@"showSports"] && twitSet){
            [self getSportsTwitPosts];
            [self getSportsIGPosts];
        }
    
        if([userDefaults boolForKey:@"showArt"] && twitSet){
            
            [self getArtIGPosts];
            [self getArtTwitPosts];
            
        }
    
        if([userDefaults boolForKey:@"showCulture"] && twitSet){
                [self getCultureIGPosts];
            [self getCultureTwitPosts];
            
        }
    
        if([userDefaults boolForKey:@"showComedy"] && twitSet){
            [self getComedyIGPosts];
            [self getComedyTwitPosts];
            
        }
    
        if([userDefaults boolForKey:@"showMusic"] && twitSet){
            
            [self getMusicIGPosts];
            [self getMusicTwitPosts];
        }
}

//creates cell with a row number (0,1,2, etc), sets the name and description as strings from event object
//from _events
//called after hitting "activate" button, numberOfSectionsInTableView times per event
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    ListViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"listViewCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listViewCell"];
    }
    
    [cell.cellBottomPart removeFromSuperview];
    
    
    BandoPost *bp = [self.bandoPosts objectAtIndex:indexPath.row];
    
    NSString *text = bp.postText;
    NSString *screenName = bp.username;
    NSString *profilePic = bp.profileImageUrl;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"@%@",screenName];
    
    if([bp.postType isEqualToString:@"instagram"]){
        [cell.realImageView setHidden:NO];
        [cell.descriptionLabel setHidden:YES];
        
        [cell.profileImage hnk_setImageFromURL:bp.igProPic];
        [cell.realImageView hnk_setImageFromURL:bp.igImageUrl];
        if([text length]>3)
            cell.igCaptionLabel.text = text;
        
        cell.cardView.frame = CGRectMake(5, 5, screenWidth-10, 250);
        
    }else{
        [cell.realImageView setHidden:YES];
        [cell.descriptionLabel setHidden:NO];
        cell.descriptionLabel.text = text;
        
        NSURL *imageURL = [NSURL URLWithString:profilePic];
        [cell.profileImage hnk_setImageFromURL:imageURL];
        cell.cardView.frame = CGRectMake(5, 5, screenWidth-10, 200);
    }
    return cell;
}

-(void)setupRefreshControl{
    
    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.myTableView
                                                                   target:self
                                                            refreshAction:@selector(sunnyControlDidStartAnimation)];
    [self endAnimationHandle];
    
}

-(void)sunnyControlDidStartAnimation{
    
    [self.bandoPosts removeAllObjects];
    self.bandoPosts = [[NSMutableArray alloc]init];
    [self grabAcceptableTwits];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self endAnimationHandle];
    });
}

-(IBAction)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
}

@end