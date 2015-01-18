//
//  ViewController.m
//  FSLineChart
//
//  Created by Arthur GUIBERT on 30/09/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "ViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "FSDataSet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self chart1]];
    //[self.view addSubview:[self chart2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Creating the charts

-(FSLineChart*)chart1 {
    // Generating some dummy data
    NSMutableArray* dataSet1Data = [NSMutableArray arrayWithCapacity:10];
    /*
    srand(time(nil));
    for(int i=0;i<10;i++) {
        int r = (rand() + rand()) % 1000;
        chartData[i] = [NSNumber numberWithInt:r + 200];
    }
     */
    dataSet1Data[0] = [NSNumber numberWithInt:10];
    dataSet1Data[1] = [NSNumber numberWithInt:15];
    dataSet1Data[2] = [NSNumber numberWithInt:12];
    dataSet1Data[3] = [NSNumber numberWithInt:7];
    dataSet1Data[4] = [NSNumber numberWithInt:12];
    dataSet1Data[5] = [NSNumber numberWithInt:8];
    
    NSMutableArray* dataSet2Data = [NSMutableArray arrayWithCapacity:10];
    dataSet2Data[0] = [NSNumber numberWithInt:2];
    dataSet2Data[1] = [NSNumber numberWithInt:5];
    dataSet2Data[2] = [NSNumber numberWithInt:8];
    dataSet2Data[3] = [NSNumber numberWithInt:11];
    dataSet2Data[4] = [NSNumber numberWithInt:10];
    dataSet2Data[5] = [NSNumber numberWithInt:5];
    
    NSMutableArray* dataSets = [NSMutableArray arrayWithCapacity:10];
    dataSets[0] = [[FSDataSet alloc] initWithData:dataSet1Data];
    dataSets[1] = [[FSDataSet alloc] initWithData:dataSet2Data];
    
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    //lineChart.verticalGridStep = 10;
    //lineChart.horizontalGridStep = 9;
    lineChart.verticalGridStep = 1;
    lineChart.horizontalGridStep = 1;
    lineChart.displayDataPoint = YES;
    lineChart.bezierSmoothing = NO;
    //lineChart.fillColor = nil;
    /*
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu",(unsigned long)item];
    };
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f", value];
    };
     */
    [lineChart setChartDataSets:dataSets];
    return lineChart;
}
-(FSLineChart*)chart2 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:101];
    for(int i=0;i<101;i++) {
        chartData[i] = [NSNumber numberWithFloat:(float)i / 30.0f + (float)(rand() % 100) / 200.0f];
    }
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 260, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 4;
    lineChart.horizontalGridStep = 2;
    lineChart.color = [UIColor fsOrange];
    lineChart.fillColor = nil;
    lineChart.labelForIndex = ^(NSUInteger item) {
        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    };
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.f €", value];
    };
    [lineChart setChartDataSets:chartData];
    return lineChart;
}
-(FSLineChart*)chart3 {
    // Generating some dummy data
    NSMutableArray* chartData = [NSMutableArray arrayWithCapacity:7];
    for(int i=0;i<7;i++) {
        chartData[i] = [NSNumber numberWithFloat: (float)i / 30.0f + (float)(rand() % 100) / 500.0f];
    }
    NSArray* months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July"];
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40, 166)];
    lineChart.verticalGridStep = 6;
    lineChart.horizontalGridStep = 3; // 151,187,205,0.2
    lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
    lineChart.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    lineChart.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f €", value];
    };
    [lineChart setChartDataSets:chartData];
    return lineChart;
}

@end
