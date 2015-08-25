//
//  AppDelegate.m
//  Bando
//
//  Created by Benjamin Harvey on 8/10/15.
//  Copyright (c) 2015 Benjamin Harvey. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "CrashHelper.h"
#import <Google/Analytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"CKxEw3xAI4MS7l6DtC8p7MFZJHyL8fpkHoL0dmlo"
                  clientKey:@"BxebY2wlJ6vvYUcBJPyp4Xd2pzCskMs86RHeo74K"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //[[CrashHelper sharedCrashHelper]checkForCrashes];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    
    
    [self setBooleanUserDefaults];
    
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    // Override point for customization after application launch.
    return YES;
}

-(void) setBooleanUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( [userDefaults objectForKey:@"showSports"]==nil )
    {
        NSLog(@"bool for key showSports is NIL");
        //        [self getSportsTwitPosts];
        //        [self getSportsIGPosts];
        [userDefaults setBool:YES forKey:@"showSports"];
        //show sports at the beginning
        
        
        BOOL flag = [userDefaults boolForKey:@"showSports"];
        if(flag){
            NSLog(@"bool for key showSports = yes");
        }else{
            NSLog(@"bool for key showSports = no");
        }
    }
    
    
    if ( ![userDefaults objectForKey:@"showArt"] )
    {
        NSLog(@"bool for key showArt is NIL");
        [userDefaults setBool:NO forKey:@"showArt"];
        
        BOOL flag = [userDefaults boolForKey:@"showArt"];
        if(flag){
            NSLog(@"bool for key showArt = yes");
        }else{
            NSLog(@"bool for key showArt = no");
        }
    }
    
    if ( ![userDefaults objectForKey:@"showCulture"] )
    {
        [userDefaults setBool:NO forKey:@"showCulture"];
        BOOL flag = [userDefaults boolForKey:@"showCulture"];
        if(flag){
            NSLog(@"bool for key showCulture = yes");
        }else{
            NSLog(@"bool for key showCulture = no");
        }
    }
    
    if ( ![userDefaults objectForKey:@"showComedy"] )
    {
        [userDefaults setBool:NO forKey:@"showComedy"];
        BOOL flag = [userDefaults boolForKey:@"showComedy"];
        if(flag){
            NSLog(@"bool for key showComedy = yes");
        }else{
            NSLog(@"bool for key showComedy = no");
        }
    }
    if ( [userDefaults objectForKey:@"showMusic"] ==nil)
    {
        //        [self getMusicTwitPosts];
        //        [self getMusicIGPosts];
        [userDefaults setBool:YES forKey:@"showMusic"];

        BOOL flag = [userDefaults boolForKey:@"showMusic"];
        if(flag){
            NSLog(@"bool for key showMusic = yes");
        }else{
            NSLog(@"bool for key showMusic = no");
        }
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
