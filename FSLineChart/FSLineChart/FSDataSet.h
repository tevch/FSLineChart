//
//  FSDataSet.h
//  FSLineChart
//
//  Created by Andrey Kan on 1/18/15.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+FSPalette.h"

@protocol DataSetValueFormatter
// list of methods and properties
-(NSString *) formatValue:(NSNumber *)number;
@end

@interface FSDataSet : NSObject

@property (nonatomic, strong) NSArray* data;

// DataSet parameters
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic) CGFloat lineWidth;

// Data points
@property (nonatomic) BOOL displayDataPoint;
@property (nonatomic) BOOL dataPointLabelOnTop;
@property (nonatomic, strong) UIColor* dataPointColor;
@property (nonatomic, strong) UIColor* dataPointBackgroundColor;
@property (nonatomic) CGFloat dataPointRadius;

// Smoothing
@property (nonatomic) BOOL bezierSmoothing;
@property (nonatomic) CGFloat bezierSmoothingTension;

//formatting
@property (nonatomic) id<DataSetValueFormatter> valueFormatter;




- (id)initWithData:(NSArray *)data;

@end
