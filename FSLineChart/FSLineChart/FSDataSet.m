//
//  FSDataSet.m
//  FSLineChart
//
//  Created by Andrey Kan on 1/18/15.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

#import "FSDataSet.h"

@implementation FSDataSet

- (id)initWithData:(NSArray *)data {
    self.data = data;
    
    [self setDefaultParameters];
    
    return self;
}

- (void)setDefaultParameters {
    _color = [UIColor fsLightBlue];
    _fillColor = [_color colorWithAlphaComponent:0.25];
    
    _bezierSmoothing = YES;
    _bezierSmoothingTension = 0.2;
    _lineWidth = 1;
    
    _displayDataPoint = NO;
    _dataPointLabelOnTop = YES;
    _dataPointRadius = 1;
    _dataPointColor = _color;
    _dataPointBackgroundColor = _color;
}

@end
