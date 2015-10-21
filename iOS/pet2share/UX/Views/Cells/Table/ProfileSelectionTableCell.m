//
//  ProfileSelectionTableCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileSelectionTableCell.h"
#import "CheckMark.h"
#import "CircleImageView.h"
#import "Pet2ShareService.h"
#import "Graphics.h"

@interface ProfileSelectionTableCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;

@end

@implementation ProfileSelectionTableCell

+ (CGFloat)height
{
    return 56.0f;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)loadDataWithImageUrl:(NSString *)imageUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                    nameText:(NSString *)nameText
                    isMaster:(BOOL)isMaster
{
    Pet2ShareService *service = [Pet2ShareService new];
    self.avatarImageView.image = [UIImage imageNamed:placeHolderImgName];
    [service loadImage:imageUrl completion:^(UIImage *image) {
        self.avatarImageView.image = image ?: [UIImage imageNamed:placeHolderImgName];
    }];
    self.nameLabel.text = nameText;
    self.roleLabel.hidden = !isMaster;
}

@end