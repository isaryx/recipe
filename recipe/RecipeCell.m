//
//  RecipeCell.m
//  recipe
//
//  Created by Vu Tran Dao Vuong on 5/28/12.
//  Copyright (c) 2012 OngSoft. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

@synthesize thumbnail = _thumbnail;
@synthesize titleLabel = _titleLabel;

#pragma mark - View Lifecycle

- (NSString *)reuseIdentifier 
{
    return @"RecipeCell";
}

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

- (id)initWithFrame:(CGRect)frame
{
     if ((self = [super initWithFrame:frame]))
     {
         self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2)];
         self.thumbnail.opaque = YES;
         
         [self.contentView addSubview:self.thumbnail];
         
         self.titleLabel = [[RecipeTitleLabel alloc] initWithFrame:CGRectMake(0, self.thumbnail.frame.size.height * 0.632, self.thumbnail.frame.size.width, self.thumbnail.frame.size.height * 0.37)];
         self.titleLabel.opaque = YES;
         [self.titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
         self.titleLabel.textColor = [UIColor whiteColor];
         self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
         self.titleLabel.numberOfLines = 2;
         [self.thumbnail addSubview:self.titleLabel];
         
         self.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
         self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.thumbnail.frame];
         self.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
         
         self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
     }
    return self;
}

@end
