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
    NSUserDefaults *userDefaults;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneMethod)];
    
    
    sportsClicked = NO;
    musicClicked = NO;
    trendingClicked = NO;
    artClicked = NO;
    cultureClicked = NO;
    comedyClicked = NO;
    // Do any additional setup after loading the view from its nib.
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ( ![userDefaults boolForKey:@"showMusic"] )
    {
    }else{
        BOOL flag = [userDefaults boolForKey:@"showMusic"];
        if(flag){
            [self.musicButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.musicButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            musicClicked = YES;
        }
    }
    
    if ( ![userDefaults boolForKey:@"showSports"] )
    {
    }else{
        BOOL flag = [userDefaults boolForKey:@"showSports"];
        if(flag){
            [self.sportsButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.sportsButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            sportsClicked = YES;
        }
    }
    
    if ( ![userDefaults boolForKey:@"showTrending"] )
    {}else{
        BOOL flag = [userDefaults boolForKey:@"showTrending"];
        if(flag){
            [self.trendingButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.trendingButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            trendingClicked = YES;
        }
    }
    
    if ( ![userDefaults boolForKey:@"showArt"] )
    {
    }else{
        BOOL flag = [userDefaults boolForKey:@"showArt"];
        if(flag){
            [self.artButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.artButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            artClicked = YES;
        }
    }
    
    if ( ![userDefaults boolForKey:@"showCulture"] )
    {
    }else{
        BOOL flag = [userDefaults boolForKey:@"showCulture"];
        if(flag){
            [self.cultureButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.cultureButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            cultureClicked = YES;
        }
    }
    
    if ( ![userDefaults boolForKey:@"showComedy"] )
    {
    }else{
        BOOL flag = [userDefaults boolForKey:@"showComedy"];
        if(flag){
            [self.comedyButton setBackgroundColor:[self colorWithHexString:@"168807"]];
            [self.comedyButton setTitleColor:[self colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
            comedyClicked = YES;
        }
    }
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
    BOOL flag = [userDefaults boolForKey:@"showMusic"];
    NSLog(flag ? @"Yes" : @"No");
    
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
    [userDefaults setBool:musicClicked forKey:@"showMusic"];
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
    [userDefaults setBool:trendingClicked forKey:@"showTrending"];
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
    
    [userDefaults setBool:cultureClicked forKey:@"showCulture"];
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
    [userDefaults setBool:sportsClicked forKey:@"showSports"];
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
    [userDefaults setBool:comedyClicked forKey:@"showComedy"];
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
    
    [userDefaults setBool:artClicked forKey:@"showArt"];
}

-(void)doneMethod{
    [self.navigationController popViewControllerAnimated:YES];
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
