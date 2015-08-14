//
//  ChooseCategoriesViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/13/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "ChooseCategoriesViewController.h"

@interface ChooseCategoriesViewController ()

@end

@implementation ChooseCategoriesViewController{
    BOOL sportsClicked;
    BOOL musicClicked;
    BOOL trendingClicked;
    BOOL artClicked;
    BOOL cultureClicked;
    BOOL comedyClicked;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sportsClicked = NO;
    musicClicked = NO;
    trendingClicked = NO;
    artClicked = NO;
    cultureClicked = NO;
    comedyClicked = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickedMusic:(CustomRoundRectButton *)sender {
//    [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
    if(!musicClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        musicClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        musicClicked = NO;
    }
}

- (IBAction)clickedTrending:(CustomRoundRectButton *)sender {
    if(!trendingClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        trendingClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        trendingClicked = NO;
    }
}

- (IBAction)clickedCulture:(CustomRoundRectButton *)sender {
    if(!cultureClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        cultureClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        cultureClicked = NO;
    }
}

- (IBAction)clickedSports:(CustomRoundRectButton *)sender {
    if(!sportsClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        sportsClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        sportsClicked = NO;
    }
}

- (IBAction)clickedComedy:(CustomRoundRectButton *)sender {
    if(!comedyClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        comedyClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        comedyClicked = NO;
    }
}

- (IBAction)clickedArt:(CustomRoundRectButton *)sender {
    if(!artClicked){
        [sender setBackgroundColor:[self colorWithHexString:@"168807"]];
        [sender setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        artClicked = YES;
    }else{
        [sender setBackgroundColor:[self colorWithHexString:@"FFFFFF"]];
        [sender setTitleColor:[self colorWithHexString:@"168807"] forState:UIControlStateNormal];
        artClicked = NO;
    }
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
