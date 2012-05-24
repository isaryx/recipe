//
//  Recipe.m
//  recipe
//
//  Created by Vu Tran on 3/27/12.
//  Copyright 2012 Perselab. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe
@synthesize recipeId = _recipeId;
@synthesize name = _name;
@synthesize serving = _serving;
@synthesize createDate = _createDate;
@synthesize imageList = _imageList;
@synthesize ingredientList = _ingredientList;
@synthesize stepList = _stepList;

- (id)init
{
    self = [super init];
    if (self) {
        _recipeId = nil;
        _name = nil;
        _serving = 0;
        _createDate = nil;
        _imageList = [[NSMutableArray alloc] init];
        _ingredientList = [[NSMutableArray alloc] init];
        _stepList = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end
