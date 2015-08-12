//
//  GridViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "GridViewController.h"
#import "GridViewCell.h"

@implementation GridViewController

@synthesize gridView, services;


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView = [[AQGridView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    [self.view addSubview:gridView];
    
    [self.gridView reloadData];
    [self addHeader];
}


- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return 16;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    
    
    GridViewCell * cell = (GridViewCell *)[aGridView dequeueReusableCellWithIdentifier:@"PlainCellIdentifier"];
    
    if ( cell == nil )
    {
        cell = [[GridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 160, 123)
                                   reuseIdentifier: PlainCellIdentifier];
    }
    
    NSURL *imageURL = [NSURL URLWithString:@"http://vignette2.wikia.nocookie.net/silkroad-online/images/a/a9/Example.jpg"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [cell.imageView setImage:[UIImage imageWithData:imageData]];
            NSLog(@"set");
        });
    });
    
    [cell.captionLabel setText:@"Sample service"];
    
    return cell;
    
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(160.0, 123) );
}

-(void) addHeader{
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,280,320,25)];
    headerLabel.text = @"Featured Post";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor greenColor];
    
    
    NSURL *imageURL = [NSURL URLWithString:@"http://vignette2.wikia.nocookie.net/silkroad-online/images/a/a9/Example.jpg"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 320, 295)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [imageView setImage:[UIImage imageWithData:imageData]];
            NSLog(@"set");
        });
    });

    [tableHeaderView addSubview:imageView];
    [tableHeaderView addSubview:headerLabel];
    
    [self.gridView setGridHeaderView:tableHeaderView];
}

@end
