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
    
    FSDataSet * dataSet1 = [[FSDataSet alloc] initWithData:dataSet1Data];
    dataSet1.displayDataPoint = NO;
    dataSet1.bezierSmoothing = NO;
    //dataSet1.color = [UIColor fsOrange];
    dataSet1.fillColor = [[UIColor fsPink] colorWithAlphaComponent:0.3];
    dataSet1.color = [[UIColor fsPink] colorWithAlphaComponent:0.3];
    dataSet1.lineWidth=0;
    dataSet1.dataPointRadius = 2;
    
    NSMutableArray* dataSet2Data = [NSMutableArray arrayWithCapacity:10];
    dataSet2Data[0] = [NSNumber numberWithInt:0];
    dataSet2Data[1] = [NSNumber numberWithInt:0];
    dataSet2Data[2] = [NSNumber numberWithInt:8];
    dataSet2Data[3] = [NSNumber numberWithInt:11];
    dataSet2Data[4] = [NSNumber numberWithInt:10];
    dataSet2Data[5] = [NSNumber numberWithInt:5];
    
    
    FSDataSet *dataSet2 = [[FSDataSet alloc] initWithData:dataSet2Data];
    dataSet2.displayDataPoint = YES;
    dataSet2.bezierSmoothing = NO;
    //dataSet2.color = [UIColor fsOrange];
    dataSet2.fillColor = [[UIColor fsLightBlue] colorWithAlphaComponent:0.3];
    dataSet2.dataPointRadius = 2;
    dataSet2.dataPointLabelOnTop=NO;
    //dataSet2.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    //dataSet2.fillColor = [dataSet2.color colorWithAlphaComponent:0.3];
    
    
    NSMutableArray* dataSets = [NSMutableArray arrayWithCapacity:10];
    dataSets[0] = dataSet1;
    dataSets[1] = dataSet2;
    
    // Creating the line chart
    FSLineChart* lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 10, 66)];
    lineChart.backgroundColor = [UIColor lightGrayColor];
    //lineChart.verticalGridStep = 10;
    //lineChart.horizontalGridStep = 9;
    lineChart.verticalGridStep = 1;
    lineChart.horizontalGridStep = 1;
    
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
    //lineChart.color = [UIColor fsOrange];
    //lineChart.fillColor = nil;
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
    //lineChart.color = [UIColor colorWithRed:151.0f/255.0f green:187.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
    //lineChart.fillColor = [lineChart.color colorWithAlphaComponent:0.3];
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
