//
//  config.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#ifndef Traffic_MTL_config_h
#define Traffic_MTL_config_h

#define BLUECOLOR [UIColor colorWithRed:106/255.0 green:205/255.0 blue:216/255.0 alpha:1.0]

#define ISFRENCH [[NSUserDefaults standardUserDefaults] boolForKey:@"lang"] //![[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"]

// LOCALIZATION

#define START (ISFRENCH?@"COMMENCER":@"START")

#define lMTL (ISFRENCH?@"Direction Montréal":@"Towards Montreal")
#define lBANLIEU (ISFRENCH?@"Direction Banlieue":@"Towards Suburbs")

#define lNORMALTIME (ISFRENCH?@"Traversée normale:":@"Average crossing:")
#define lUNAVAILABLE (ISFRENCH?@"Non disponible":@"Unavailable")


#define lPULL (ISFRENCH?@"Tirez pour mettre à jour":@"Pull to refresh")
#define lKEEP  (ISFRENCH?@"Encore un peu...":@"Keep pulling...")
#define lRELEASE (ISFRENCH?@"Liberez pour mettre à jour":@"Release to update!")

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.9]

#define FONT [UIFont fontWithName:@"Ubuntu-M" size:20]

#define ISIPHONE5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

#define MENU_WIDTH 100

#define RIVE_SUD NO
#define RIVE_NORD YES



// TUTORIAL
#define lEVALUATE (ISFRENCH?@"Evalue Evalue Evalue Evalue Evalue Evalue Evalue Evalue Evalue Evalue ":@"")

#define lWITHOUTTRAFFIC (ISFRENCH?@"100% = Vitesse sans trafic":@"100% = Speed without traffic")
#define lWITHTRAFFIC (ISFRENCH?@"0% = Le pont a coulé dans le fleuve": @"0% = The bridge has sunk in the river")
#define lPLUS (ISFRENCH?@"+... = Le temps additionnel requis pour traverser le pont":@"+... = The amount of additional time it takes to cross the bridge")

#define lOURMISSION  (ISFRENCH?@"Notre Mission":@"Our Goal")
#define lMISSION (ISFRENCH?@"Faciliter les aller-retours à Montréal en donnant des informations pertinentes quant à la congestion sur les ponts de la ville.":@"")

#define lOURSTRATEGY (ISFRENCH?@"Notre Stratégie":@"Our Strategy")

#define lSTRATEGY (ISFRENCH?@"Évaluer la moyenne des temps d'accès et de traversée des ponts afin déterminer leur vitesse de circulation.":@"")

#endif
