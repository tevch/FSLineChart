//
//  FSLineChart.m
//  FSLineChart
//
//  Created by Arthur GUIBERT on 30/09/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <QuartzCore/QuartzCore.h>
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "FSDataSet.h"

@interface FSLineChart ()

@property (nonatomic, strong) NSMutableArray* dataSets;

@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;
@property (nonatomic) CGMutablePathRef initialPath;
@property (nonatomic) CGMutablePathRef newPath;

@end

@implementation FSLineChart {
    int labelFontSize;
}
/*
- (id)init {
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
    }
    return self;
}
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
    }
    return self;
}

-(FSDataSet *) getLongestDataSet {
    FSDataSet *longestDataSet = nil;
    for(FSDataSet *dataSet in _dataSets) {
        if(longestDataSet==nil) {
            longestDataSet = dataSet;
        } else if(dataSet.data.count > longestDataSet.data.count){
            longestDataSet = dataSet;
        }
    }
    
    return longestDataSet;
}

- (void)setChartDataSets:(NSArray *)chartDataSets
{
    
    self.layer.sublayers = nil;
    
    _dataSets = [NSMutableArray arrayWithArray:chartDataSets];
    
    [self computeBounds];
    
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    // No data
    if(isnan(_max)) {
        _max = 1;
    }
    
    [self strokeChart];
    
    [self strokeDataPoints];
    
    if(_labelForValue) {
        for(int i=0;i<_verticalGridStep;i++) {
            CGPoint p = CGPointMake(_marginHorizontal + (_valueLabelPosition == ValueLabelRight ? _axisWidth : 0), _axisHeight + _marginVertical - (i + 1) * _axisHeight / _verticalGridStep);
            
            NSString* text = _labelForValue(minBound + (maxBound - minBound) / _verticalGridStep * (i + 1));
            
            if(!text)
                continue;
            
            CGRect rect = CGRectMake(_marginHorizontal, p.y + 2, self.frame.size.width - _marginHorizontal * 2 - 4.0f, 14);
            
            float width =
            [text
             boundingRectWithSize:rect.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:_valueLabelFont }
             context:nil]
            .size.width;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - width - 6, p.y + 2, width + 2, 14)];
            label.text = text;
            label.font = _valueLabelFont;
            label.textColor = _valueLabelTextColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = _valueLabelBackgroundColor;
            
            [self addSubview:label];
        }
    }
    
    FSDataSet *longestDataSet = [self getLongestDataSet];
    if(_labelForIndex) {
        float scale = 1.0f;
        int q = (int)longestDataSet.data.count / _horizontalGridStep;
        scale = (CGFloat)(q * _horizontalGridStep) / (CGFloat)(longestDataSet.data.count - 1);
        
        for(int i=0;i<_horizontalGridStep + 1;i++) {
            NSInteger itemIndex = q * i;
            if(itemIndex >= longestDataSet.data.count)
            {
                itemIndex = longestDataSet.data.count - 1;
            }
            
            NSString* text = _labelForIndex(itemIndex);
            
            if(!text)
                continue;
            
            CGPoint p = CGPointMake(_marginHorizontal + i * (_axisWidth / _horizontalGridStep) * scale, _axisHeight + _marginVertical);
            
            CGRect rect = CGRectMake(_marginHorizontal, p.y + 2, self.frame.size.width - _marginHorizontal * 2 - 4.0f, 14);
            
            float width =
            [text
             boundingRectWithSize:rect.size
             options:NSStringDrawingUsesLineFragmentOrigin
             attributes:@{ NSFontAttributeName:_indexLabelFont }
             context:nil]
            .size.width;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - 4.0f, p.y + 2, width + 2, 14)];
            label.text = text;
            label.font = _indexLabelFont;
            label.textColor = _indexLabelTextColor;
            label.backgroundColor = _indexLabelBackgroundColor;
            
            [self addSubview:label];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self drawGrid];
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, _axisLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    
    // draw coordinate axis
    CGContextMoveToPoint(ctx, _marginHorizontal, _marginVertical);
    CGContextAddLineToPoint(ctx, _marginHorizontal, _axisHeight + _marginVertical + 3);
    CGContextStrokePath(ctx);
    
    FSDataSet *longestDataSet = [self getLongestDataSet];
    
    float scale = 1.0f;
    int q = (int)longestDataSet.data.count / _horizontalGridStep;
    scale = (CGFloat)(q * _horizontalGridStep) / (CGFloat)(longestDataSet.data.count - 1);
    
    
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    // draw grid
    if(_drawInnerGrid) {
        for(int i=0;i<_horizontalGridStep;i++) {
            CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
            CGContextSetLineWidth(ctx, _innerGridLineWidth);
            
            CGPoint point = CGPointMake((1 + i) * _axisWidth / _horizontalGridStep * scale + _marginHorizontal, _marginVertical);
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, point.x, _axisHeight + _marginVertical);
            CGContextStrokePath(ctx);
            
            CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
            CGContextSetLineWidth(ctx, _axisLineWidth);
            CGContextMoveToPoint(ctx, point.x - 0.5f, _axisHeight + _marginVertical);
            CGContextAddLineToPoint(ctx, point.x - 0.5f, _axisHeight + _marginVertical + 3);
            CGContextStrokePath(ctx);
        }
        
        for(int i=0;i<_verticalGridStep + 1;i++) {
            // If the value is zero then we display the horizontal axis
            CGFloat v = maxBound - (maxBound - minBound) / _verticalGridStep * i;
            
            if(v == 0) {
                CGContextSetLineWidth(ctx, _axisLineWidth);
                CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
            } else {
                CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
                CGContextSetLineWidth(ctx, _innerGridLineWidth);
            }
            
            CGPoint point = CGPointMake(_marginHorizontal, (i) * _axisHeight / _verticalGridStep + _marginVertical);
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, _axisWidth + _marginHorizontal, point.y);
            CGContextStrokePath(ctx);
        }
    }
    
}

- (void)strokeChart
{
    for(FSDataSet *dataSet in self.dataSets) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        UIBezierPath *noPath = [UIBezierPath bezierPath];
        UIBezierPath* fill = [UIBezierPath bezierPath];
        UIBezierPath* noFill = [UIBezierPath bezierPath];
    
        CGFloat minBound = MIN(_min, 0);
        CGFloat maxBound = MAX(_max, 0);
    
        CGFloat scale = _axisHeight / (maxBound - minBound);
    
        noPath = [self getLinePath:0 ofDataSet:dataSet withSmoothing:dataSet.bezierSmoothing close:NO];
        path = [self getLinePath:scale ofDataSet:dataSet withSmoothing:dataSet.bezierSmoothing close:NO];
    
        noFill = [self getLinePath:0 ofDataSet:dataSet withSmoothing:dataSet.bezierSmoothing close:YES];
        fill = [self getLinePath:scale ofDataSet:dataSet withSmoothing:dataSet.bezierSmoothing close:YES];
    
        if(dataSet.fillColor) {
            CAShapeLayer *fillLayer = [CAShapeLayer layer];
            fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
            fillLayer.bounds = self.bounds;
            fillLayer.path = fill.CGPath;
            fillLayer.strokeColor = nil;
            fillLayer.fillColor = dataSet.fillColor.CGColor;
            fillLayer.lineWidth = 0;
            fillLayer.lineJoin = kCALineJoinRound;
        
            [self.layer addSublayer:fillLayer];
        
            CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            fillAnimation.duration = _animationDuration;
            fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            fillAnimation.fillMode = kCAFillModeForwards;
            fillAnimation.fromValue = (id)noFill.CGPath;
            fillAnimation.toValue = (id)fill.CGPath;
            [fillLayer addAnimation:fillAnimation forKey:@"path"];
        }
    
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [dataSet.color CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = dataSet.lineWidth;
        pathLayer.lineJoin = kCALineJoinRound;
    
        [self.layer addSublayer:pathLayer];
    
        if(dataSet.fillColor) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
            pathAnimation.toValue = (__bridge id)(path.CGPath);
            [pathLayer addAnimation:pathAnimation forKey:@"path"];
        } else {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            [pathLayer addAnimation:pathAnimation forKey:@"path"];
        }
    }
}

- (void)strokeDataPoints
{
    CGFloat minBound = MIN(_min, 0);
    CGFloat maxBound = MAX(_max, 0);
    
    CGFloat scale = _axisHeight / (maxBound - minBound);
    
    //CAShapeLayer *dataPointsLayer = [CAShapeLayer layer];
    
    for(int d=0;d<self.dataSets.count;d++) {
        FSDataSet *dataSet = self.dataSets[d];
        for(int i=0;i<dataSet.data.count;i++) {
            CGPoint p = [self getPointForIndex:i ofDataSet:dataSet withScale:scale];
            p.y +=  minBound * scale;

            if(dataSet.displayDataPoint) {
                UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - dataSet.dataPointRadius, p.y - dataSet.dataPointRadius, dataSet.dataPointRadius * 2, dataSet.dataPointRadius * 2)];
                
                CAShapeLayer *fillLayer = [CAShapeLayer layer];
                fillLayer.frame = CGRectMake(p.x, p.y, dataSet.dataPointRadius, dataSet.dataPointRadius);
                fillLayer.bounds = CGRectMake(p.x, p.y, dataSet.dataPointRadius, dataSet.dataPointRadius);
                fillLayer.path = circle.CGPath;
                fillLayer.strokeColor = dataSet.dataPointColor.CGColor;
                fillLayer.fillColor = dataSet.dataPointBackgroundColor.CGColor;
                fillLayer.lineWidth = 1;
                fillLayer.lineJoin = kCALineJoinRound;
        
                [self.layer addSublayer:fillLayer];
            }
        
            CATextLayer *label = [[CATextLayer alloc] init];
            //[label setFont:@"Helvetica-Bold"];
            [label setFontSize:self->labelFontSize];
            //label.opaque = TRUE;
            CGFloat scale = [[UIScreen mainScreen] scale];
            label.contentsScale = scale;
            //[label setFrame:CGRectMake(p.x-10, dataSet.dataPointLabelOnTop?p.y+-12:p.y+12, 20, 10)];
            [label setFrame:CGRectMake(p.x-10, dataSet.dataPointLabelOnTop?p.y+-12:p.y+2, 20, 10)];
            [label setAlignmentMode:kCAAlignmentCenter];
            [label setForegroundColor:[[UIColor blackColor] CGColor]];
        
            NSNumber* number = dataSet.data[i];
            NSString *strValue = [NSString stringWithFormat:@"%@", number ];
            [label setString:strValue];
        
            [self.layer addSublayer:label];
        }
    }
}

- (void)setDefaultParameters
{
    self->labelFontSize = 8;
    _verticalGridStep = 3;
    _horizontalGridStep = 3;
    //_margin = 15.0f;
    _marginVertical = 12.0f;
    _marginHorizontal = 12.0f;
    _axisWidth = self.frame.size.width - 2 * _marginHorizontal;
    _axisHeight = self.frame.size.height - 2 * _marginVertical;
    _axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _innerGridColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _drawInnerGrid = NO;
    _innerGridLineWidth = 0.5;
    _axisLineWidth = 1;
    _animationDuration = 0.5;
    
    
    // Labels attributes
    _indexLabelBackgroundColor = [UIColor clearColor];
    _indexLabelTextColor = [UIColor grayColor];
    _indexLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    
    _valueLabelBackgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    _valueLabelTextColor = [UIColor grayColor];
    _valueLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    _valueLabelPosition = ValueLabelRight;
}

- (void)computeBounds
{
    _min = MAXFLOAT;
    _max = -MAXFLOAT;
    
    for(FSDataSet *dataSet in self.dataSets) {
    for(int i=0;i<dataSet.data.count;i++) {
        NSNumber* number = dataSet.data[i];
        if([number floatValue] < _min)
            _min = [number floatValue];
        
        if([number floatValue] > _max)
            _max = [number floatValue];
    }
    }
    
    // The idea is to adjust the minimun and the maximum value to display the whole chart in the view, and if possible with nice "round" steps.
    _max = [self getUpperRoundNumber:_max forGridStep:_verticalGridStep];
    
    if(_min < 0) {
        // If the minimum is negative then we want to have one of the step to be zero so that the chart is displayed nicely and more comprehensively
        float step;
        
        if(_verticalGridStep > 3) {
            step = fabs(_max - _min) / (float)(_verticalGridStep - 1);
        } else {
            step = MAX(fabs(_max - _min) / 2, MAX(fabs(_min), fabs(_max)));
        }
        
        step = [self getUpperRoundNumber:step forGridStep:_verticalGridStep];
        
        float newMin,newMax;
        
        if(fabs(_min) > fabs(_max)) {
            int m = ceilf(fabs(_min) / step);
            
            newMin = step * m * (_min > 0 ? 1 : -1);
            newMax = step * (_verticalGridStep - m) * (_max > 0 ? 1 : -1);
            
        } else {
            int m = ceilf(fabs(_max) / step);
            
            newMax = step * m * (_max > 0 ? 1 : -1);
            newMin = step * (_verticalGridStep - m) * (_min > 0 ? 1 : -1);
        }
        
        if(_min < newMin) {
            newMin -= step;
            newMax -=  step;
        }
        
        if(_max > newMax + step) {
            newMin += step;
            newMax +=  step;
        }
        
        _min = newMin;
        _max = newMax;
        
        if(_max < _min) {
            float tmp = _max;
            _max = _min;
            _min = tmp;
        }
        
    }
}

- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    if(value <= 0)
        return 0;
    
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 4);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    
    return n * scale / 4.0f;
}

- (void)setGridStep:(int)gridStep
{
    _verticalGridStep = gridStep;
    _horizontalGridStep = gridStep;
}

- (CGPoint)getPointForIndex:(NSInteger)idx ofDataSet:(FSDataSet *)dataSet withScale:(CGFloat)scale
{
    if(idx < 0 || idx >= dataSet.data.count)
        return CGPointZero;
    
    // Compute the point in the view from the data with a set scale
    NSNumber* number = dataSet.data[idx];
    return CGPointMake(_marginHorizontal + idx * (_axisWidth / (dataSet.data.count - 1)), _axisHeight + _marginVertical - [number floatValue] * scale);
}

- (UIBezierPath*)getLinePath:(float)scale ofDataSet:(FSDataSet *)dataSet withSmoothing:(BOOL)smoothed close:(BOOL)closed
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    if(smoothed) {
        for(int i=0;i<dataSet.data.count - 1;i++) {
            CGPoint controlPoint[2];
            CGPoint p = [self getPointForIndex:i ofDataSet:dataSet withScale:scale];
            
            // Start the path drawing
            if(i == 0)
                [path moveToPoint:p];
            
            CGPoint nextPoint, previousPoint, m;
            
            // First control point
            nextPoint = [self getPointForIndex:i + 1 ofDataSet:dataSet withScale:scale];
            previousPoint = [self getPointForIndex:i - 1 ofDataSet:dataSet withScale:scale];
            m = CGPointZero;
            
            if(i > 0) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (nextPoint.x - p.x) / 2;
                m.y = (nextPoint.y - p.y) / 2;
            }
            
            controlPoint[0].x = p.x + m.x * dataSet.bezierSmoothingTension;
            controlPoint[0].y = p.y + m.y * dataSet.bezierSmoothingTension;
            
            // Second control point
            nextPoint = [self getPointForIndex:i + 2 ofDataSet:dataSet withScale:scale];
            previousPoint = [self getPointForIndex:i ofDataSet:dataSet withScale:scale];
            p = [self getPointForIndex:i + 1 ofDataSet:dataSet withScale:scale];
            m = CGPointZero;
            
            if(i < dataSet.data.count - 2) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (p.x - previousPoint.x) / 2;
                m.y = (p.y - previousPoint.y) / 2;
            }
            
            controlPoint[1].x = p.x - m.x * dataSet.bezierSmoothingTension;
            controlPoint[1].y = p.y - m.y * dataSet.bezierSmoothingTension;
            
            [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
        
    } else {
        for(int i=0;i<dataSet.data.count;i++) {
            if(i > 0) {
                [path addLineToPoint:[self getPointForIndex:i ofDataSet:dataSet withScale:scale]];
            } else {
                [path moveToPoint:[self getPointForIndex:i ofDataSet:dataSet withScale:scale]];
            }
        }
    }
    
    if(closed) {
        // Closing the path for the fill drawing
        [path addLineToPoint:[self getPointForIndex:dataSet.data.count - 1 ofDataSet:dataSet withScale:scale]];
        [path addLineToPoint:[self getPointForIndex:dataSet.data.count - 1 ofDataSet:dataSet withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 ofDataSet:dataSet withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 ofDataSet:dataSet withScale:scale]];
    }
    
    return path;
}



@end