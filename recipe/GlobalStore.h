//
//  GlobalStore.h
//  recipe
//
//  Created by Vu Tran Dao Vuong on 6/16/12.
//  Copyright (c) 2012 OngSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "recipeGlobal.h"

@interface GlobalStore : NSObject
{
    User* _loggedUser;
}

@property (nonatomic) User *loggedUser;

+(GlobalStore *) sharedStore;

-(void)setLoggedUser:(User *)loggedUser;
-(User*)loggedUser;

@end
