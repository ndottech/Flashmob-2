//
//  AllDealCell.m
//  Supermain
//
//  Created by APPLE on 01/06/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "eventcell.h"

@implementation eventcell

@synthesize titleLable,location_lbl;
@synthesize adduser_btn;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
