//
//  InterfaceController.m
//  Thymer WatchKit Extension
//
//  Created by Steve Sparks on 3/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *scrollGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *targetLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceSlider *slider;

@property (nonatomic) CGFloat minutesRequested;
@property (nonatomic) NSTimer *currentTimer;
@property (nonatomic) NSDate *currentTimerDate;

@property (nonatomic) NSTimer *checkTimer;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    self.minutesRequested = 2;
    [self.slider setValue:2.0];
    [self refreshClock:nil];
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshClock:) userInfo:nil repeats:YES];
    [super willActivate];
}

- (void)didDeactivate {
    [self.checkTimer invalidate];
    self.currentTimerDate = nil;
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)sliderValueChanged:(float)value {
    NSString *txt = [NSString stringWithFormat:@"%.f minutes", value];
    self.minutesRequested = value;
    [self.targetLabel setText:txt];
}

- (void)showTimerDate:(NSDate *)date {
    if([date isEqual:self.currentTimerDate] || self.currentTimerDate == date)
        return;

    if(self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
    NSLog(@"Showing %@", date);
    if(date) {
        NSTimeInterval interval = [date timeIntervalSinceNow];
        self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(refreshClock:) userInfo:nil repeats:NO];
        self.currentTimerDate = date;
        [self presentControllerWithName:@"currentTimer" context:@{ @"date": date }];
    }
}

- (IBAction)startThymerTapped {
    [self startTimer];
}

- (IBAction)quickFiveTapped {
    self.minutesRequested = 5.0;
    [self startTimer];
}

- (IBAction)quickTenTapped {
    self.minutesRequested = 10.0;
    [self startTimer];
}

- (IBAction)quickHourTapped {
    self.minutesRequested = 60.0;
    [self startTimer];
}

- (IBAction)stopTimerTapped {

}

- (void)startTimer {
    NSTimeInterval t = self.minutesRequested * 60;
    NSDictionary *dict = @{ @"newTimeInterval" : @(t) };
    [WKInterfaceController openParentApplication:dict
                                           reply:^(NSDictionary *reply, NSError *error)
     {
         NSDate *d = reply[@"fireDate"];
         [self showTimerDate:d];
     }];
}

- (void)refreshClock:(NSTimer *)timer {
    [WKInterfaceController openParentApplication:@{}
                                           reply:^(NSDictionary *reply, NSError *error)
     {
         NSDate *d = reply[@"fireDate"];
         [self showTimerDate:d];
     }];
}

- (void)handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)localNotification {
    if([identifier isEqualToString:@"snoozeTwoMinutes"]){
        self.minutesRequested = 2.0;
        [self startTimer];
    }
}


- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification {
    if([identifier isEqualToString:@"snoozeTwoMinutes"]){
        self.minutesRequested = 2.0;
        [self startTimer];
    }
}


@end



