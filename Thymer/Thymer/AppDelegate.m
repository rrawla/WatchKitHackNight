//
//  AppDelegate.m
//  Thymer
//
//  Created by Steve Sparks on 3/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "AppDelegate.h"

NSString * const TimerDidChangeNotification = @"TimerDidChangeNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [application registerUserNotificationSettings:[UIUserNotificationSettings  settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    NSArray *notes = [application scheduledLocalNotifications];
    for(UILocalNotification *note in notes) {
        NSLog(@"Schedule note %@", note.fireDate);
        self.timerDate = note.fireDate;
    }
    return YES;
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

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {

    NSNumber *timeInterval = userInfo[@"newTimeInterval"];
    if(timeInterval) {
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow:timeInterval.floatValue];
        self.timerDate = d;
    }

    if(userInfo[@"cancel"]) {
        self.timerDate = nil;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(self.timerDate)
            reply(@{ @"fireDate" : self.timerDate });
        else
            reply(@{});

    });
}

- (NSDate *)timerDate {
    UILocalNotification *note = [[[UIApplication sharedApplication] scheduledLocalNotifications] firstObject];
    if(note) {
        return note.fireDate;
    }
    return nil;
}

- (void)setTimerDate:(NSDate *)timerDate {
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];

    if(timerDate) {
        UILocalNotification *note = [[UILocalNotification alloc] init];
        note.fireDate = timerDate;
        note.alertTitle = @"DING!";
        note.alertBody = @"Your Timer Went Off";
        note.alertAction = @"Ok!";
        [app scheduleLocalNotification:note];

        NSLog(@"Schedule note %@", timerDate);
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TimerDidChangeNotification object:self];

    });
}

@end
