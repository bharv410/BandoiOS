//
//  BandoPost.m
//  Bando
//
//  Created by Benjamin Harvey on 8/12/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "BandoPost.h"

@implementation BandoPost

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if (self.postText != ((BandoPost *)other).postText)
        return NO;
    return YES;
}

@end
