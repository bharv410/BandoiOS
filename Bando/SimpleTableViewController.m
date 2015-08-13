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
    
    InstagramEngine *engine = [InstagramEngine sharedEngine];
    [engine getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"sucess");
    } failure:^(NSError *error, NSInteger statusCode) {

    }];
    
    
    self.twitPosts = [[NSMutableArray alloc]init];
    
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                   consumerSecret:TWITTER_CONSUMER_SECRET];
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {

        [self.twitter getUserTimelineWithScreenName:@"Hot97"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"Kendricklamar"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"drake"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"metroboomin"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"applemusic"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"1future"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        [self.twitter getUserTimelineWithScreenName:@"meekmill"
                                              count:1
                                       successBlock:^(NSArray *statuses) {
                                           [self.twitPosts addObjectsFromArray:statuses];
                                           [self.myTableView reloadData];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"%@",error.description);
                                       }];
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
        // ...
    }];
    
    
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
    cardSizeArray = [[NSArray alloc]initWithObjects:@200,@200,@300, @300, @200 , @200 ,@200,@200 ,@200 ,nil];
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
    return [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning you're going to want to change this
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning you're going to want to change this
    
    if([self.twitPosts count]>0)
        return [self.twitPosts count];
    else
        return 0;
}

//creates cell with a row number (0,1,2, etc), sets the name and description as strings from event object
//from _events
//called after hitting "activate" button, numberOfSectionsInTableView times per event
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"listViewCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listViewCell"];
    }
    
    NSString *text = [[self.twitPosts objectAtIndex:indexPath.row] valueForKey:@"text"];
    NSString *screenName = [[self.twitPosts objectAtIndex:indexPath.row] valueForKeyPath:@"user.screen_name"];
    NSString *profilePic = [[self.twitPosts objectAtIndex:indexPath.row] valueForKeyPath:@"user.profile_image_url_https"];
    NSString *dateString = [[self.twitPosts objectAtIndex:indexPath.row] valueForKey:@"created_at"];
    
    cell.titleLabel.text = text;
    cell.nameLabel.text = [NSString stringWithFormat:@"@%@",screenName];
    cell.descriptionLabel.text = [descriptionArray objectAtIndex:indexPath.row];
    
    //%%% I made the cards pseudo dynamic, so I'm asking the cards to change their frames depending on the height of the cell
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    cell.cardView.frame = CGRectMake(5, 5, screenWidth-10, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10);
    
    cell.cellBottomPart.frame = CGRectMake(cell.cellBottomPart.frame.origin.x, cell.cellBottomPart.frame.origin.y, screenWidth, cell.cellBottomPart.frame.size.height);
    
    NSInteger row=indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *futurePic = @"https://igcdn-photos-f-a.akamaihd.net/hphotos-ak-xap1/t51.2885-15/10948938_1695988977287373_1424991187_n.jpg";
        //NSURL *imageURL = [NSURL URLWithString:[[Listname objectAtIndex:indexPath.item]coverURL]];
        NSURL *imageURL = [NSURL URLWithString:profilePic];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //set image if below condition satisfies
            if([tableView indexPathForCell:cell] . row == row){
                cell.profileImage.image = [UIImage imageWithData:imageData];
            }
        });
    });
    return cell;
}

@end