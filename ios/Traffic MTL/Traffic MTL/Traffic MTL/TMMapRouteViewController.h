//
//  TMMapRouteViewController.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-30.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TMMapRouteViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
