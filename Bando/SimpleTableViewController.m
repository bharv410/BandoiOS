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

NSString * const TWITTER_CONSUMER_KEY = @"QAM6jdb170hyMhJmMwoqbjRCg";
NSString * const TWITTER_CONSUMER_SECRET = @"X70RAkYKUDtJH4Hpg5CizyvkJ7zZvrTFbAtOEjLkFQmoSdQ87i";

@interface SimpleTableViewController (){
    NSArray *photoArray;
    NSMutableArray *titleArray;
    NSArray *nameArray;
    NSArray *descriptionArray;
    NSArray *cardSizeArray;
    NSUserDefaults *userDefaults;
    InstagramEngine *engine;
    }

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize table dat
    userDefaults = [NSUserDefaults standardUserDefaults];
    
//    if ( ![userDefaults valueForKey:@"version"] )
//    {
//        // CALL your Function;
//        ChooseCategoriesViewController *ccvc = [[ChooseCategoriesViewController alloc]init];
//        [self.navigationController pushViewController:ccvc animated:YES];
//        
//        // Adding version number to NSUserDefaults for first version:
//        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
//    }
    
    
    
    self.navigationController.navigationBar.topItem.title = @"Bando";


    self.myTableView.separatorColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]; //%%% This is so if you overscroll, the color is still gray

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, screenWidth, self.myTableView.frame.size.height);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editCategories)];
    
    engine = [InstagramEngine sharedEngine];
    [self getTwitPosts];
    
}

- (void)viewDidAppear:(BOOL)animated{
    self.bandoPosts = [[NSMutableArray alloc]init];
    titleArray = [[NSMutableArray alloc]init];
    
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
    //%%% this is asking for the number in the cardSizeArray.  If you're seriously
    // thinking about making your cards dynamic, they should depend on something more reliable
    // for example, facebook's post sizes depend on whether it's a status update or photo, etc
    // so there should be a switch statement in here that returns different heights depending on
    // what kind of post it is.  Also, don't forget to change the height of the
    // cardView if you use dynamic cards
    
    BandoPost *thisPost = [self.bandoPosts objectAtIndex:indexPath.row];
    if([thisPost.postType isEqualToString:@"instagram"]){
        return [((NSNumber*)@250)intValue];
    }else{
    return [((NSNumber*)@200)intValue];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning you're going to want to change this
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning you're going to want to change this
    
    if([self.bandoPosts count]>0)
        return [self.bandoPosts count];
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BandoPost *bp = [self.bandoPosts objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bp.postLink]];
    
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
                                               bp.postLink= [cur valueForKey:@"url"];
                                               bp.postText = [cur valueForKey:@"text"];
                                               bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                               if(![self.bandoPosts containsObject:bp])
                                                   [self.bandoPosts addObject:bp];
                                           }
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           //NSLog(@"%@",error.description);
                                       }];
    }
    
    
}

-(void)getSportsTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"KingJames",@"kobebryant",@"kdtrey5",@"Chris_Broussard",@"NikeBasketball",@"uabasketball",@"RealSkipBayless", @"stephenasmith", nil];

        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:1
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.postLink= [cur valueForKey:@"url"];
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
        [engine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
    [self.myTableView reloadData];
}

-(void)getArtIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"143795932",@"176915912",@"13613836",@"787132",nil];
    
    for(NSString *username in igUsers){
        [engine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
    [self.myTableView reloadData];
}

-(void)getMusicIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"14455831",@"6720655",@"25945306",@"18900337"
                        ,@"266319242",@"10685362",@"18900337",nil];
    
    for(NSString *username in igUsers){
        [engine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
    [self.myTableView reloadData];
}

-(void)getComedyIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"1535836050",@"10245461",@"6590609",@"15209885",nil];
    
    for(NSString *username in igUsers){
        [engine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                 [self.bandoPosts addObject:bp];
            }
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
    [self.myTableView reloadData];
}

-(void)getCultureIGPosts{
    NSArray *igUsers = [[NSArray alloc]initWithObjects:@"6380930",@"174247675",@"12281817",@"185087057",@"28011380",nil];
    
    for(NSString *username in igUsers){
        [engine getMediaForUser:username count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            for(InstagramMedia *cur in media){
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = cur.link;
                bp.username = cur.user.username;
                bp.postType = @"instagram";
                bp.postText = cur.caption.text;
                bp.createdAt = cur.createdDate;
                bp.igProPic = cur.user.profilePictureURL;
                bp.igImageUrl = cur.standardResolutionImageURL;
                if(![self.bandoPosts containsObject:bp])
                    [self.bandoPosts addObject:bp];
            }
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"%@",error.description);
        }];
    }
    [self.myTableView reloadData];
}

-(void)getCultureTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"nicekicks",@"kyliejenner", nil];
    
        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:1
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.postLink= [cur valueForKey:@"url"];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                               [self shuffleArray];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)getComedyTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"desusnice",@"dahoodvines",@"lilduval", nil];
    
    
    
        for(NSString *username in twitUsers){
            [self.twitter getUserTimelineWithScreenName:username
                                                  count:1
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.postLink= [cur valueForKey:@"url"];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                               [self shuffleArray];
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
                                                  count:1
                                           successBlock:^(NSArray *statuses) {
                                               for(NSDictionary *cur in statuses){
                                                   BandoPost *bp = [[BandoPost alloc]init];
                                                   bp.username = [cur valueForKeyPath:@"user.screen_name"];
                                                   bp.postType = @"twitter";
                                                   bp.postLink= [cur valueForKey:@"url"];
                                                   bp.postText = [cur valueForKey:@"text"];
                                                   bp.profileImageUrl = [cur  valueForKeyPath:@"user.profile_image_url_https"];
                                                   [self.bandoPosts addObject:bp];
                                               }
                                               [self.myTableView reloadData];
                                               [self shuffleArray];
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
}

-(void)getTwitPosts{
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                   consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        [self grabAcceptableTwits];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)grabAcceptableTwits{
    if ( [userDefaults objectForKey:@"showSports"]==nil )
    {
        NSLog(@"no bool for key showSports");
//        [self getSportsTwitPosts];
//        [self getSportsIGPosts];
        [userDefaults setBool:YES forKey:@"showSports"]; //show sports at the beginning
    }else{
        NSLog(@"yes bool for key showSports");
        BOOL flag = [userDefaults boolForKey:@"showSports"];
        if(flag){
            [self getSportsTwitPosts];
            [self getSportsIGPosts];
        }
    }
    
    
    if ( ![userDefaults boolForKey:@"showArt"] )
    {
        NSLog(@"yes bool for key showArt");
        [userDefaults setBool:NO forKey:@"showArt"];
    }else{
        NSLog(@"yes bool for key showArt");
        BOOL flag = [userDefaults boolForKey:@"showArt"];
        if(flag){
            [self getArtTwitPosts];
            [self getArtIGPosts];
        }
    }
    
    if ( ![userDefaults boolForKey:@"showCulture"] )
    {
        [userDefaults setBool:NO forKey:@"showCulture"];
    }else{
        BOOL flag = [userDefaults boolForKey:@"showCulture"];
        if(flag){
            [self getCultureTwitPosts];
            [self getCultureIGPosts];
        }
    }
    
    if ( ![userDefaults boolForKey:@"showComedy"] )
    {
        [userDefaults setBool:NO forKey:@"showComedy"];
    }else{
        BOOL flag = [userDefaults boolForKey:@"showComedy"];
        if(flag){
            [self getComedyTwitPosts];
            [self getComedyIGPosts];
        }
    }
    if ( [userDefaults objectForKey:@"showMusic"] ==nil)
    {
//        [self getMusicTwitPosts];
//        [self getMusicIGPosts];
        [userDefaults setBool:YES forKey:@"showMusic"];
    }else{
        BOOL flag = [userDefaults boolForKey:@"showMusic"];
        if(flag){
            [self getMusicTwitPosts];
            [self getMusicIGPosts];
        }
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self shuffleArray];
//        [self.myTableView reloadData];
//    });
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
//        cell.realImageView.frame = CGRectMake(cell.realImageView.frame.origin.x, cell.realImageView.frame.origin.y+4, cell.realImageView.frame.size.width, cell.realImageView.frame.size.height);
        
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

@end