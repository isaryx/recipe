//
//  IngredientListViewController.h
//  recipe
//
//  Created by SaRy on 4/5/12.
//  Copyright (c) 2012 OngSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ingredientListTable;
@end