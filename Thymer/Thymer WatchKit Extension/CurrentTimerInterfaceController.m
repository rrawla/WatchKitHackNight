//
//  CurrentTimerInterfaceController.m
//  Thymer
//
//  Created by Steve Sparks on 3/28/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "CurrentTimerInterfaceController.h"


@interface CurrentTimerInterfaceController()
@property (nonatomic) NSTimer *currentTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *runningTimer;

@end


@implementation CurrentTimerInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSDictionary *dict = context;
    NSDate *d = dict[@"date"];
    [self showTimerDate:d];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)stopTimerTapped {
    [self cancelTimerWithCompletion:^{
        [self dismissController];
    }];
}

- (void)cancelTimerWithCompletion:(void(^)(void))completion {
    if(self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
        NSDictionary *dict = @{ @"cancel" : @"yes" };
        [WKInterfaceController openParentApplication:dict
                                               reply:^(NSDictionary *reply, NSError *error)
         {
             completion();
         }];
    }
}

- (void)showTimerDate:(NSDate *)date {
    if(self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
    NSLog(@"Showing %@", date);
    [self.runningTimer setDate:date];
    if(date) {
        NSTimeInterval interval = [date timeIntervalSinceNow];
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(refreshClock:) userInfo:nil repeats:NO];
        [self.runningTimer start];
    } else {
        [self popController];
    }
}

- (void)refreshClock:(NSTimer *)timer {
    [WKInterfaceController openParentApplication:@{}
                                           reply:^(NSDictionary *reply, NSError *error)
     {
         NSDate *d = reply[@"fireDate"];
         [self showTimerDate:d];
     }];
}



@end



