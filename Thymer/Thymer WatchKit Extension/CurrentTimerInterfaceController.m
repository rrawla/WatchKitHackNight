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
@property (nonatomic) NSDate *currentTimerDate;
@end


@implementation CurrentTimerInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    NSDictionary *dict = context;
    [self setTitle:@" "];
    NSDate *d = dict[@"date"];
    [self showTimerDate:d];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshClock:) userInfo:nil repeats:YES];
    [super willActivate];
}

- (void)didDeactivate {
    [self.currentTimer invalidate];
    self.currentTimerDate = nil;
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
    if([date isEqual:self.currentTimerDate] || self.currentTimerDate == date)
        return;
    NSLog(@"Showing %@", date);
    self.currentTimerDate = date;
    if(date) {
        [self.runningTimer setDate:date];
        [self.runningTimer start];
    } else {
        [self dismissController];
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



