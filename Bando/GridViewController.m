//
//  GridViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "GridViewController.h"
#import "GridViewCell.h"
#import <Parse/Parse.h>
#import "BandoPost.h"
#import "ArticleDetailViewController.h"

@implementation GridViewController

@synthesize gridView, bandoPosts;


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height,screenWidth,screenHeight-50)];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    [self.view addSubview:gridView];
    self.navigationController.navigationBar.topItem.title = @"Bando";

    [self getOtherPosts];
    [self getFeaturedPost];
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
                bp.postText = object[@"postText"];
                bp.createdAt = object.createdAt;
                bp.imageUrl = object[@"imageUrl"];
                bp.uniqueId = object.objectId;
                bp.viewCount = object[@"viewCount"];
                //[bandoPosts addObject:bp];
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,280,320,25)];
            headerLabel.text = bp.postText;
            headerLabel.textColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:28];
            headerLabel.backgroundColor = [UIColor greenColor];
            
            
            NSString *url = bp.imageUrl;
            NSURL *imageURL = [[NSURL alloc]initWithString:url];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 320, 295)];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imgData = [NSData dataWithContentsOfURL:imageURL];
                if (imgData) {
                    UIImage *image = [UIImage imageWithData:imgData];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                imageView.image = image;
                            [self.gridView reloadData];
                        });
                    }
                }
            });
            
            [tableHeaderView addSubview:imageView];
            [tableHeaderView addSubview:headerLabel];
            
            [self.gridView setGridHeaderView:tableHeaderView];
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            [self.gridView setGridFooterView:tableFooterView];
            [self.gridView reloadData];
        }
    }];
    
    //[self addHeader];
}
-(void)getOtherPosts{
    bandoPosts = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"VerifiedBandoPost"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
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
                [bandoPosts addObject:bp];
            }
            [self.gridView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

    
    BandoPost *clickedPost = [bandoPosts objectAtIndex:index];
    NSString *siteUrl = clickedPost.postLink;
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = siteUrl;
    [self.navigationController pushViewController:articleDetail animated:YES];
    //[self performSegueWithIdentifier:@"showRecipeDetail" sender:nil];
    
}


- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return 10;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    
    
    GridViewCell * cell = (GridViewCell *)[aGridView dequeueReusableCellWithIdentifier:@"PlainCellIdentifier"];
    
    if ( cell == nil )
    {
        cell = [[GridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 180, 153)
                                   reuseIdentifier: PlainCellIdentifier];
    }
    
    cell.imageView.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    
    BandoPost *bp = [bandoPosts objectAtIndex:index];
    
    NSString *url = bp.imageUrl;
    NSURL *imageURL = [[NSURL alloc]initWithString:url];
    [cell.captionLabel setText:bp.postText];
    bp = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:imageURL];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    GridViewCell *updateCell = (id)[gridView cellForItemAtIndex:index];
                    if (updateCell)
                        updateCell.imageView.image = image;
                });
            }
        }
    });
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
        //NSIndexPath *indexPath = [self.gridView indexOfSelectedItem];
        BandoPost *clickedPost = [bandoPosts objectAtIndex:[self.gridView indexOfSelectedItem]];
        NSString *siteUrl = clickedPost.postLink;
        
        ArticleDetailViewController *articleDetail = [[ArticleDetailViewController alloc]init];
        articleDetail.websiteString = siteUrl;
        NSLog(@"yay");
    }
}


- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(160.0, 123) );
}

-(void) addHeader{
    

}

@end
