//
//  ScatterPlotViewController.h
//  Csekkolj
//
//  Created by András Dóczi on 2013.04.25..
//  Copyright (c) 2013 András Dóczi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ScatterPlotViewController : UIViewController <CPTPlotDataSource>

@property (nonatomic, strong) CPTGraphHostingView *hostView;

@end