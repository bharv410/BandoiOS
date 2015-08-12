//
//  BandoPost.h
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BandoPost : NSObject

@property (nonatomic, strong) NSString *postLink;
@property (nonatomic, strong) NSString *siteSource;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *postTimeAgo;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSNumber *viewCount;

@end
