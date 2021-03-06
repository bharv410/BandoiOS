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
@property (nonatomic, strong) NSString *postDeepLink;
@property (nonatomic, strong) NSString *siteSource;
@property (nonatomic, copy) NSString *postText;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *postTimeAgo;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSURL *igProPic;
@property (nonatomic, strong) NSURL *igImageUrl;
@property (nonatomic, strong) NSNumber *viewCount;

@end
