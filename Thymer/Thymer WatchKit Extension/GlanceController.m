//
//  GlanceController.m
//  Thymer WatchKit Extension
//
//  Created by Steve Sparks on 3/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "GlanceController.h"


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *timerLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [WKInterfaceController openParentApplication:@{} reply:^(NSDictionary *reply, NSError *error){
        NSDate *r = reply[@"fireDate"];
        [self.timerLabel setDate:r];
        [self.timerLabel start];
    }];

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


@end



