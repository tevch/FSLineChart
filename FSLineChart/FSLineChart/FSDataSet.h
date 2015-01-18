//
//  FSDataSet.h
//  FSLineChart
//
//  Created by Andrey Kan on 1/18/15.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSDataSet : NSObject

@property (nonatomic, strong) NSArray* data;

- (id)initWithData:(NSArray *)data;

@end
