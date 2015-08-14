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

NSString * const TWITTER_CONSUMER_KEY = @"QAM6jdb170hyMhJmMwoqbjRCg";
NSString * const TWITTER_CONSUMER_SECRET = @"X70RAkYKUDtJH4Hpg5CizyvkJ7zZvrTFbAtOEjLkFQmoSdQ87i";

@interface SimpleTableViewController (){
    NSArray *photoArray;
    NSArray *titleArray;
    NSArray *nameArray;
    NSArray *descriptionArray;
    NSArray *cardSizeArray;
    }

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize table dat
    
    self.bandoPosts = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.topItem.title = @"Bando";
    
    InstagramEngine *engine = [InstagramEngine sharedEngine];
    
    [engine getMediaForUser:@"14455831" count:2 maxId:nil withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        for(InstagramMedia *cur in media){
            BandoPost *bp = [[BandoPost alloc]init];
            bp.postLink = cur.link;
            bp.username = cur.user.username;
            bp.postType = @"instagram";
            bp.postText = cur.caption.text;
            bp.createdAt = cur.createdDate;
            bp.igProPic = cur.user.profilePictureURL;
            bp.igImageUrl = cur.standardResolutionImageURL;
            [self.bandoPosts addObject:bp];
            NSLog(@"added");
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error, NSInteger serverStatusCode) {
        NSLog(@"%@",error.description);
    }];
    
    [self getTwitPosts];
    [self loadExampleData];
    self.myTableView.separatorColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1]; //%%% This is so if you overscroll, the color is still gray

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.myTableView reloadData];
    });
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, screenWidth, self.myTableView.frame.size.height);
    
}

-(void)loadExampleData
{
    /*
     this is just example data and you shouldn't be using your table like this because it's static.
     For example, if you want to have a news feed, you should be using an NSMutableArray and pulling
     the information from the internet somehow.  If you'd like some help figuring out the logistics,
     I'd be happy to help, contact me at cwrichardkim@gmail.com or twitter: @cwRichardKim
     */
    photoArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    titleArray = [[NSArray alloc]initWithObjects:@"First Card",@"OOOOH CHIIIILDD",@"Look! This One's Bigger", @"First Card",@"OOOOH CHIIIILDD",@"Look! This One's Bigger",@"last one", nil];
    
    nameArray = [[NSArray alloc]initWithObjects:@"Things are gonna get",@"Easieerrrrr",@"ooooooh chiiiiild", @"Things are gonna get",@"Easieerrrrr",@"ooooooh chiiiiild",@"last name",nil];
    descriptionArray = [[NSArray alloc]initWithObjects:@"Dance off bro",@"Things are gonna get brighter",@"oooh oooh baeebeeee",@"Dance off bro",@"Things are gonna get brighter",@"oooh oooh baeebeeee",@"last description", nil];
    cardSizeArray = [[NSArray alloc]initWithObjects:@200,@200,@200, @200, @200 , @200 ,@200,@200 ,@200 ,nil];
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
        return [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue];
    }else{
    return [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue];
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

-(void)getTwitPosts{
    NSArray *twitUsers = [[NSArray alloc]initWithObjects:@"Hot97",@"Kendricklamar",@"drake",@"metroboomin",@"applemusic",@"1future", nil];
    
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                   consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
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
                                           } errorBlock:^(NSError *error) {
                                               NSLog(@"%@",error.description);
                                           }];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
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
        [cell.descriptionLabel removeFromSuperview];
        [cell.realImageView setHidden:NO];
        
        [cell.profileImage hnk_setImageFromURL:bp.igProPic];
        [cell.realImageView hnk_setImageFromURL:bp.igImageUrl];
        [cell.descriptionLabel setHidden:YES];
        
    }else{
        cell.descriptionLabel.text = text;
        [cell.realImageView setHidden:YES];
        [cell.descriptionLabel setHidden:NO];
        
        NSURL *imageURL = [NSURL URLWithString:profilePic];
        [cell.profileImage hnk_setImageFromURL:imageURL];
    }
    cell.cardView.frame = CGRectMake(5, 5, screenWidth-10, 200);
    return cell;
}

@end