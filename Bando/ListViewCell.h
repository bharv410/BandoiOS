//
//  ListViewCell.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *realImageView;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIView *cellBackground;
@property (strong, nonatomic) IBOutlet UIView *cellBottomPart;
@property (strong, nonatomic) IBOutlet UIImageView *socialMediaImage;

@property (strong, nonatomic) IBOutlet UILabel *igCaptionLabel;

@end
