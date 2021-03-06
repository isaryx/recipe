//
//  CategoryXMLHandler.m
//  recipe
//
//  Created by SaRy on 4/6/12.
//  Copyright (c) 2012 Perselab. All rights reserved.
//

#import "CategoryXMLHandler.h"

@implementation CategoryXMLHandler

-(id) initWithCategoryArray:(NSMutableArray*)categoryArray{
    if (self = [super init]) {
        _currentObject = nil;
        _currentCategory = nil;
        _currentRecipe = nil;
        _categoryArray = categoryArray;
        _total = nil;
    }
    return self;
}

-(id) initObjectAfterElementStarting:(NSString *)elementName{
    if ([elementName isEqualToString:@"categories"]){
        return self;
    }
    if ([elementName isEqualToString:@"category"]) {
		_currentObject = [[Category alloc] init];
		return self;
	}
    if ([elementName isEqualToString:@"recipes"]){
        return self;
    }
    if ([elementName isEqualToString:@"recipe"]){
        _currentObject = [[Recipe alloc] init];
        return self;
    }
    if ([elementName isEqualToString:@"images"]) {
        return self;
    }
    if ([elementName isEqualToString:@"name"]
        || [elementName isEqualToString:@"serving"]
        || [elementName isEqualToString:@"createDate"]
        || [elementName isEqualToString:@"imageId"])
    {
        return self;
    }
	return nil;
}

-(void) afterElementStarting:(NSString *)elementName withAttributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"categories"])
        _total = [[NSNumber alloc] initWithInteger:[[attributeDict objectForKey:@"total"] intValue]];
    if ([elementName isEqualToString:@"category"]){
        if ([_currentObject isKindOfClass:[Category class]])
            _currentCategory = (Category *)_currentObject;
    }
    if ([elementName isEqualToString:@"recipe"]) {
        if ([_currentObject isKindOfClass:[Recipe class]])
            _currentRecipe = (Recipe *)_currentObject;
    }
}

-(void) afterElementEnding:(NSString *)elementName{
    if ([elementName isEqualToString:@"name"]){
        if ([_currentObject isKindOfClass:[Category class]])
            [_currentCategory setName:_chars];
        if ([_currentObject isKindOfClass:[Recipe class]])
            [_currentRecipe setName:_chars];
    }
    if ([elementName isEqualToString:@"serving"])
        [_currentRecipe setServing:[_chars intValue]];
    if ([elementName isEqualToString:@"imageId"])
        [[_currentRecipe imageList] addObject:_chars];
    if ([elementName isEqualToString:@"recipe"]) {
        [[_currentCategory latestRecipes] addObject:_currentRecipe];
        _currentRecipe = nil;
        _currentObject = nil;
    }
    if ([elementName isEqualToString:@"category"]) {
        [_categoryArray addObject:_currentCategory];
		_currentCategory = nil;
        _currentObject = nil;
	}
}

-(NSString*) getWrappedRootNode
{
	return @"categories";
}

@end
