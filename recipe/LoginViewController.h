//
//  LoginViewController.h
//  recipe
//
//  Created by ongsoft on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    UITextField *activeTextField;
}

- (IBAction)dismissKeyboard;
- (IBAction)onLoginTap;

@end
