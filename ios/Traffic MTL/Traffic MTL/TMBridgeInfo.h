//
//  TMBridgeInfo.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-23.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBridgeInfo : NSObject

@property float ratio;

@property int realTime;
@property int time;

@property NSString* bridgeName;

@property int direction;

@property int delay;

@property int percentage;

@property int rgb;

@property int shore;

@property NSString* condition;
@end
