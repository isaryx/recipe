//
//  Category.h
//  recipe
//
//  Created by ongsoft on 3/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject{
    NSString* _categoryId;
    NSString* _name;
    NSMutableArray* _latestRecipes;
}

@property (nonatomic) NSString *categoryId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *latestRecipes;

@end
