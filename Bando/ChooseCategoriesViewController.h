//
//  ChooseCategoriesViewController.h
//  Bando
//
//  Created by Benjamin Harvey on 8/13/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRoundRectButton.h"

@interface ChooseCategoriesViewController : UIViewController
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *musicButton;
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *trendingButton;
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *cultureButton;
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *sportsButton;
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *comedyButton;
@property (strong, nonatomic) IBOutlet CustomRoundRectButton *artButton;

- (IBAction)clickedMusic:(CustomRoundRectButton *)sender;
- (IBAction)clickedTrending:(CustomRoundRectButton *)sender;
- (IBAction)clickedCulture:(CustomRoundRectButton *)sender;
- (IBAction)clickedSports:(CustomRoundRectButton *)sender;
- (IBAction)clickedComedy:(CustomRoundRectButton *)sender;
- (IBAction)clickedArt:(CustomRoundRectButton *)sender;

@end
