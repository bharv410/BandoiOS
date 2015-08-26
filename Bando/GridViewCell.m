//
//  GridViewCell.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "GridViewCell.h"
#import <Haneke/Haneke.h>

@implementation GridViewCell

@synthesize captionLabel,imageView;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self)
    {
        
        UIView* mainView = [[UIView alloc] initWithFrame:self.bounds];
        [mainView setBackgroundColor:[UIColor clearColor]];
    
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 160)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];
        
        captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 160, 60)];
        [captionLabel setFont:[UIFont systemFontOfSize:14]];
        captionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        captionLabel.numberOfLines = 0;
        captionLabel.textAlignment = NSTextAlignmentCenter;
        
        [mainView addSubview:imageView];
        [mainView addSubview:captionLabel];
        [self.contentView addSubview:mainView];
    }
    
    return self;
}

- (UIView *) contentView
{
    if ( _contentView == nil )
    {
        _contentView = [[UIView alloc] initWithFrame: self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _contentView.autoresizesSubviews = YES;
        self.autoresizesSubviews = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [_contentView.layer setValue: [NSNumber numberWithBool: YES] forKey: @"KoboHackInterestingLayer"];
        [self addSubview: _contentView];
    }
    return ( _contentView );
}


- (void)prepareForReuse
{
    [self.imageView hnk_cancelSetImage];
    self.imageView.image = nil;
}


@end
