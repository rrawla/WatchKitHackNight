//
//  ViewController.m
//  Thymer
//
//  Created by Steve Sparks on 3/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.minimumDate = [NSDate date];
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    if(d.timerDate) {
        self.datePicker.date = d.timerDate;
        self.selectedDate = d.timerDate;
        [self countdownLabelFromSelectedDate];
    } else {
        self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60 * 5];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(id)sender {
    self.selectedDate = self.datePicker.date;
    [self scheduleNote];
    [self countdownLabelFromSelectedDate];
}

- (void)scheduleNote {

    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];

    AppDelegate *d = [app delegate];
    d.timerDate = self.selectedDate;

    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.fireDate = self.selectedDate;
    note.alertTitle = @"DING!";
    note.alertBody = @"Your Timer Went Off";
    note.alertAction = @"Ok!";
    [[UIApplication sharedApplication] scheduleLocalNotification:note];

    NSLog(@"Schedule note %@", self.selectedDate);
}

- (void)countdownLabelFromSelectedDate {
    __block NSDateFormatter *fmt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = NSDateFormatterShortStyle;
        fmt.timeStyle = NSDateFormatterShortStyle;
    });
    self.countdownLabel.text = [NSString stringWithFormat:@"%@", [fmt stringFromDate:self.selectedDate]];

}
@end
