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

#define BLUECOLOR [UIColor colorWithRed:44/255.0 green:190/255.0 blue:150/255.0 alpha:1.0]

#define ISFRENCH ![[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"]

// LOCALIZATION

#define lNORMALTIME (ISFRENCH?@"Traversée normale:":@"Average crossing:")
#define lUNAVAILABLE (ISFRENCH?@"Non disponible":@"Unavailable")


#endif
