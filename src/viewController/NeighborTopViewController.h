//
//  NeighborTopViewController.h
//  myFans
//
//  Created by wonliao on 13/1/16.
//  Copyright (c) 2013年 wonliao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ECSlidingViewController.h"

@interface NeighborTopViewController : UIViewController<MKMapViewDelegate>{
    
    MKMapView *mapView;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
- (IBAction)backButtonTapped:(id)sender;

@end

