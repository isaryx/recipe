//
//  RecipeViewController.h
//  recipe
//
//  Created by Vu Tran on 3/28/12.
//  Copyright 2012 Perselab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    Recipe* _recipe;
}

@property (weak, nonatomic) IBOutlet UITableView *recipeDetailsTable;
@property (nonatomic) Recipe *recipe;
@property (strong, nonatomic) IBOutlet UITableViewCell *slideShowCell;
@property (strong, nonatomic) IBOutlet UIView *recipeHeaderView;
@property (strong, nonatomic) IBOutlet UIView *recipeInfoView;
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;

@end
