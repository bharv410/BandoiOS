//
//  GridViewCell.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "GridViewCell.h"

@implementation GridViewCell

@synthesize captionLabel, imageView;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self)
    {
    
//        UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 220)];
//        [mainView setBackgroundColor:[UIColor clearColor]];
        
//        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 4, 142, 117)];
//        [frameImageView setImage:[UIImage imageNamed:@"tab-mask.png"]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 160)];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 160, 40)];
        [self.captionLabel setFont:[UIFont systemFontOfSize:14]];
        self.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.captionLabel.numberOfLines = 0;
        
//        [mainView addSubview:imageView];
//        [mainView addSubview:frameImageView];
//        [mainView addSubview:captionLabel];
        
        self.imageView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:captionLabel];
    }
    
    return self;
}

@end
