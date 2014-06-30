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


#define lRIVE_SUD (ISFRENCH?@"Rive Sud":@"South Shore")
#define lRIVE_NORD (ISFRENCH?@"Rive Nord":@"North Shore")
#define lHELP (ISFRENCH?@"À propos":@"About")
// TUTORIAL

#define lWELCOME (ISFRENCH?@"Montréal est une ville redoutée pour le trafic de ses ponts. Trafic Montréal est la solution simple et efficace afin d'éviter les endroits de congestion.":@"")

#define lEVALUATE (ISFRENCH?@"Trafic Montréal évalue en temps réel le temps d'accès aux ponts de l'île.":@"Traffic Montreal evaluates in real-time the access time of the island's bridges.")

#define lOURDYNAMIC (ISFRENCH?@"Notre Dynamique":@"Our Dynamic")
#define lWITHOUTTRAFFIC (ISFRENCH?@"100% = Vitesse sans trafic":@"100% = Speed without traffic")
#define lWITHTRAFFIC (ISFRENCH?@"0% = Le pont a coulé dans le fleuve": @"0% = The bridge has sunk in the river")
#define lPLUS (ISFRENCH?@"+... = Le temps additionnel requis pour traverser le pont":@"+... = The amount of additional time it takes to cross the bridge")

#define lOURMISSION  (ISFRENCH?@"Notre Mission":@"Our Goal")
#define lMISSION (ISFRENCH?@"Faciliter les aller-retours à Montréal en donnant des informations pertinentes quant à la congestion sur les ponts de la ville.":@"Make your daily commute to and from the city less painful by having access to pertinent information about the traffic statuses of the various bridges.")

#define lOURSTRATEGY (ISFRENCH?@"Notre Stratégie":@"Our Strategy")

#define lSTRATEGY (ISFRENCH?@"Évaluer la moyenne des temps d'accès et de traversée des ponts afin déterminer leur vitesse de circulation.":@"Get the real time the changes of the traffic flow on and around the bridges. This offers the users an accurate overview their possible way back home instantly")



#endif
