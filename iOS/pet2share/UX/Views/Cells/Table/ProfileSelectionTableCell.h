//
//  ProfileSelectionTableCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckMark.h"

@interface ProfileSelectionTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CheckMark *checkMark;

+ (CGFloat)height;
- (void)loadDataWithImageUrl:(NSString *)imageUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                    nameText:(NSString *)nameText
                    isMaster:(BOOL)isMaster;

@end
