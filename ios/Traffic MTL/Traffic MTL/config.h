//
//  config.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#ifndef Traffic_MTL_config_h
#define Traffic_MTL_config_h

#define MAPS_API_KEY @"Fmjtd%7Cluur2d0and%2Ca0%3Do5-9arg5w"//@"AIzaSyCYTQN5--nNG46_8VLuOngzoC7wn8W9AnA"

#define BLUECOLOR [UIColor colorWithRed:106/255.0 green:205/255.0 blue:216/255.0 alpha:1.0]

#define ISFRENCH ![[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"]

// LOCALIZATION

#define lNORMALTIME (ISFRENCH?@"Traversée normale:":@"Average crossing:")
#define lUNAVAILABLE (ISFRENCH?@"Non disponible":@"Unavailable")


#define lPULL (ISFRENCH?@"Tirez pour mettre à jour":@"Pull to refresh")
#define lKEEP  (ISFRENCH?@"Encore un peu...":@"Keep pulling...")
#define lRELEASE (ISFRENCH?@"Liberez pour mettre à jour":@"Release to update!")

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.9]

#endif
