//
//  Cell.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Cell


@synthesize thumbnail;
@synthesize label;


- (id)init {
	
    if (self = [super init]) {
		
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        self.frame = CGRectMake(0, 0, screenWidth/2 + 80, screenWidth/2);
		
		[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
		
		self.thumbnail.layer.cornerRadius = 4.0;
		self.thumbnail.layer.masksToBounds = YES;
		self.thumbnail.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.thumbnail.layer.borderWidth = 1.0;
        
        self.thumbnail.frame = CGRectMake(10, 10, screenWidth/2 -20, screenWidth/2 -20);
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        [self.thumbnail setClipsToBounds:YES];
        
        self.timeStampLabel.frame = CGRectMake(10, screenWidth/2 -8, screenWidth/2 -20, 17);
        self.timeStampLabel.textAlignment = NSTextAlignmentLeft;
        
        self.label.frame = CGRectMake(10, screenWidth/2 +10, screenWidth/2 -20, 60);
        [self.label setFont:[UIFont systemFontOfSize:14]];
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        self.label.numberOfLines = 0;
        self.label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.view];
	}
	
    return self;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


@end
