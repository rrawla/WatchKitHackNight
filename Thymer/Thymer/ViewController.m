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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTimerSet:) name:TimerDidChangeNotification object:nil];

    self.datePicker.minimumDate = [NSDate date];
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    NSDate *timerDate = d.timerDate;

    self.selectedDate = timerDate;
    self.datePicker.date = timerDate?:[NSDate dateWithTimeIntervalSinceNow:60 * 5];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(id)sender {
    self.selectedDate = self.datePicker.date;
    [self scheduleNote];
}

- (void)scheduleNote {
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *d = [app delegate];
    d.timerDate = self.selectedDate;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    static NSDateFormatter *fmt = nil;
    if(!fmt) {
        fmt = [[NSDateFormatter alloc] init];
        fmt.dateStyle = NSDateFormatterShortStyle;
        fmt.timeStyle = NSDateFormatterMediumStyle;
    };
    if(_selectedDate) {
        self.countdownLabel.text = [NSString stringWithFormat:@"%@", [fmt stringFromDate:_selectedDate]];
    } else {
        self.countdownLabel.text = @"None Scheduled";
    }
}

- (void)newTimerSet:(NSNotification*)note {
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    NSDate *timerDate = d.timerDate;
    self.selectedDate = timerDate;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.selectedDate = nil;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
