//
//  SavedArticlesController.m
//  Bando
//
//  Created by Benjamin Harvey on 9/9/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "SavedArticlesController.h"
#import <Parse/Parse.h>
#import "ArticleDetailViewController.h"
#import "BandoPost.h"

@implementation SavedArticlesController
@synthesize booksArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.booksArray = nil;
    self.booksArray = [[NSMutableArray alloc]init];
    
    
    [self getFeaturedPost];
    PFQuery *query = [PFQuery queryWithClassName:@"VerifiedBandoPost"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                BandoPost *bp = [[BandoPost alloc]init];
                bp.postLink = object[@"postLink"];
                bp.postType = @"article";
                bp.postText = object[@"postText"];
                bp.createdAt = object.createdAt;
                bp.imageUrl = object[@"imageUrl"];
                bp.uniqueId = object.objectId;
                bp.viewCount = object[@"viewCount"];
                
                if([[NSUserDefaults standardUserDefaults]
                    objectForKey:bp.postLink] != nil && ![self.booksArray containsObject:bp]){
                    [self.booksArray addObject:bp];
                }
                
            }
            [self.tableView reloadData];
            if ([self.booksArray count] < 1) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"No Saved Posts"
                                      message:@"Go to some posts & click save!"
                                      delegate:self  // set nil if you don't want the yes button callback
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil, nil];
                [alert show];
                
            }
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
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
            
            if([[NSUserDefaults standardUserDefaults]
                objectForKey:bp.postLink] != nil && ![self.booksArray containsObject:bp]){
                [self.booksArray addObject:bp];
            }
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
    BandoPost *bp = (BandoPost *)[self.booksArray objectAtIndex:indexPath.row];
    articleDetail.websiteString = bp.postLink;
    articleDetail.viewCount = bp.viewCount;
    articleDetail.postString = bp.postText;
    [self.navigationController pushViewController:articleDetail animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.booksArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    BandoPost *curPost = (BandoPost *)[self.booksArray objectAtIndex:indexPath.row];
    cell.textLabel.text = curPost.postText;
    return cell;
}

@end
