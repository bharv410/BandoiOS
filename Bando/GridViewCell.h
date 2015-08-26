//
//  GridViewCell.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "BandoPost.h"

@interface GridViewCell : AQGridViewCell
{
    BandoPost * currentPost;
    UIImageView * imageView;
    UILabel * captionLabel;
}
@property(nonatomic,retain) BandoPost * currentPost;

@end