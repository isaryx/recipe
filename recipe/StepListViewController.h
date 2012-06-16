//
//  StepListViewController.h
//  recipe
//
//  Created by SaRy on 4/5/12.
//  Copyright (c) 2012 Perselab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepListViewController : UIViewController
{
    NSInteger selectedIndex;
    NSArray* _steps;
}

@property (weak, nonatomic) IBOutlet UITableView *stepListTable;
@property (nonatomic) NSArray* steps;
@end
