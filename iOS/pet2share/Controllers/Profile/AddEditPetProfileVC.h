//
//  AddEditPetProfileVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/12/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "BaseNavigationVC.h"

typedef NS_ENUM(NSInteger, PetProfileMode) {
    AddPetProfile,
    EditPetProfile
};

@class Pet;

@interface AddEditPetProfileVC : BaseNavigationVC

@property (nonatomic, strong) Pet *pet;
@property (nonatomic, assign) PetProfileMode petProfileMode;

@end
