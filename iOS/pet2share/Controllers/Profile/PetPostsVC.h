//
//  PetPostsVC.h
//  pet2share
//
//  Created by Tony Kieu on 8/8/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationVC.h"

@class ParsePet;

@interface PetPostsVC : BaseNavigationVC

@property (nonatomic, strong) ParsePet *pet;

@end
