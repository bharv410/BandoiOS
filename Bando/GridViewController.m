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
#import <Haneke/Haneke.h>

@implementation GridViewController{
    NSString *featuredPostLink;
}

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
            featuredPostLink = bp.postLink;
                bp.postType = @"article";
                bp.postText = object[@"text"];
                bp.createdAt = object.createdAt;
                bp.imageUrl = object[@"imageUrl"];
                bp.uniqueId = object.objectId;
                bp.viewCount = object[@"viewCount"];
                //[bandoPosts addObject:bp];
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)];
            
            
            NSString *url = bp.imageUrl;
            NSURL *imageURL = [[NSURL alloc]initWithString:url];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, screenWidth-20, screenWidth-20)];
            
            
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
            
            [self.gridView setGridHeaderView:tableHeaderView];
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            [self.gridView setGridFooterView:tableFooterView];
            [self.gridView reloadData];
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            [self.gridView.gridHeaderView addGestureRecognizer:singleFingerTap];
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

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if(featuredPostLink!=nil){
        NSString *siteUrl = featuredPostLink;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailViewController *articleDetail = (ArticleDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"articleDetail"];
        articleDetail.websiteString = siteUrl;
        [self.navigationController pushViewController:articleDetail animated:YES];
    }
    //Do stuff here...
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
        cell = [[GridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 180, 220)
                                   reuseIdentifier: PlainCellIdentifier];
    }
    
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.imageView.image = nil; // or cell.poster.image = [UIImage imageNamed:@"placeholder.png"];
    
    BandoPost *bp = [bandoPosts objectAtIndex:index];
    
    NSString *url = bp.imageUrl;
    NSURL *imageURL = [[NSURL alloc]initWithString:url];
    [cell.captionLabel setText:bp.postText];
    bp = nil;
    [cell.imageView hnk_setImageFromURL:imageURL];
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
    return ( CGSizeMake(180.0, 220) );
}

-(void) addHeader{
    

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

@end
