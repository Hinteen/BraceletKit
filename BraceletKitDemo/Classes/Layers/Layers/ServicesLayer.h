//
//  ServicesLayer.h
//  AXKit
//
//  Created by xaoxuu on 07/05/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "BaseServices.h"

@class ServicesLayer;
extern ServicesLayer *services;

@interface ServicesLayer : BaseServices



+ (instancetype)sharedInstance;

@end
