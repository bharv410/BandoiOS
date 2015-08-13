//
//  ArticleDetailViewController.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [self addBackButtonWithTitle:@"back"];
    
    // Do any additional setup after loading the view.
    
//    NSURL *websiteUrl = [NSURL URLWithString:self.websiteString];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
//    [self.webView loadRequest:urlRequest];
//    self.navTitle.title = self.websiteStri
    
    UIColor *greenColor = [self colorWithHexString:@"168807"];
    
    UIImage *image = [self imageWithColor:greenColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    //[self getBackBtn];
    //UIView *topBar = [[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth, 50)];
    //[topBar setBackgroundColor:greenColor];
    
    
    //[self.view addSubview:topBar];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,50,screenWidth,screenHeight-90)];
    _webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.websiteString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    NSLog(@"WebView: %@", _webView);
    
    self.navBar.topItem.title = self.websiteString;
    
    UIView *bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight-60, screenWidth, 60)];
    [bottomBar setBackgroundColor:greenColor];
    [self.view addSubview:bottomBar];
    
}

- (void)addBackButtonWithTitle:(NSString *)title
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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

-(void)getBackBtn
{
    UIButton *Btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setFrame:CGRectMake(0.0f,0.0f,50.0f,30.0f)];
    [Btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"back.png"]]  forState:UIControlStateNormal];
    //[Btn setTitle:@"OK" forState:UIControlStateNormal];
    //Btn.titleLabel.font = [UIFont fontWithName:@"Georgia" size:14];
    [Btn addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    [self.navigationItem setLeftBarButtonItem:addButton];
}


- (void)backButtonPressed
{
    // write your code to prepare popview
    [self.navigationController popViewControllerAnimated:YES];
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

@end
