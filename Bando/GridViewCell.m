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
    
        UIView* mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 240)];
        [mainView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(39, 34, 132, 170)];
        [frameImageView setBackgroundColor:[UIColor whiteColor]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 160)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView setClipsToBounds:YES];
        
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 160, 60)];
        [self.captionLabel setFont:[UIFont systemFontOfSize:14]];
        self.captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.captionLabel.numberOfLines = 0;
        self.captionLabel.textAlignment = NSTextAlignmentCenter;
        
        [mainView addSubview:frameImageView];
        [mainView addSubview:imageView];
        [mainView addSubview:captionLabel];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        mainView.layer.borderColor = [UIColor whiteColor].CGColor;
        mainView.layer.borderWidth = 2.0f;
        _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        _contentView.layer.borderWidth = 2.0f;
        
        [self.contentView addSubview:frameImageView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.captionLabel];
    }
    
    return self;
}

@end
