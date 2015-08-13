//
//  SimpleTableViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "ListViewCell.h"

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
    // Initialize table data
    
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
    cardSizeArray = [[NSArray alloc]initWithObjects:@200,@200,@300, @300, @200 , @200 ,@200 ,nil];
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
    return 7;
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
    
    //cell.profileImage.image = [UIImage imageNamed:[photoArray objectAtIndex:indexPath.row]];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [nameArray objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [descriptionArray objectAtIndex:indexPath.row];
    
    //%%% I made the cards pseudo dynamic, so I'm asking the cards to change their frames depending on the height of the cell
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [cell setInsideBGFrame:CGRectMake(20, 5, screenWidth-20, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-20)];
     [cell setFrame:CGRectMake(10, 5, screenWidth-10, [((NSNumber*)[cardSizeArray objectAtIndex:indexPath.row])intValue]-10)];
    
    return cell;
}

@end