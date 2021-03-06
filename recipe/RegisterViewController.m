//
//  RegisterViewController.m
//  recipe
//
//  Created by Vu Tran on 3/26/12.
//  Copyright 2012 Perselab. All rights reserved.
//

#import "RegisterViewController.h"
#import "GlobalStore.h"
#import "MBProgressHUD.h"
#import "NSStringUtil.h"
#import "ASIForm2DataRequest.h"
#import "UserXMLHandler.h"

@implementation RegisterViewController
@synthesize userName;
@synthesize email;
@synthesize password;
@synthesize repassword;
@synthesize formBackground;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithParentRef:(AuthViewController*)parentViewController{
    self = [super init];
    if (self) {
        _parentController = parentViewController;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imageFromBackground = [[UIImage imageNamed:@"form_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(11, 0, 11, 0)];
    [[self formBackground] setImage:imageFromBackground];
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setRepassword:nil];
    [self setFormBackground:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Register feature
- (IBAction)onRegisterTap{
    [self dismissKeyboard];
    if ([trimSpaces([userName text]) length] != 0
        && [trimSpaces([email text]) length] != 0
        && [NSStringUtil stringIsValidEmail:[email text]]
        && [[password text] length] != 0)
    {
        if([self.repassword.text isEqualToString:self.password.text])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [hud setLabelText:@"Registering..."];
            _user = [[User alloc] init];
            [_user setName:[userName text]];
            [_user setPassword:[password text]];
            [_user setEmail:[email text]];

             NSURL *url = [NSURL URLWithString:[GlobalStore registerLink]];
        
            __weak __block ASIForm2DataRequest *request = [ASIForm2DataRequest requestWithURL:url];
//            __weak ASI2HTTPRequest *weakRequest = request;
            [request setPostValue:[userName text] forKey:@"un"];
            [request setPostValue:[password text] forKey:@"pw"];
            [request setPostValue:[email text] forKey:@"em"];
        
            [request setCompletionBlock:^{
//                ASIHTTPRequest *request = weakRequest;
//                if (!request) return;
                if (request.responseStatusCode == 200) {
                    UserXMLHandler* handler = [[UserXMLHandler alloc] initWithUser:_user];
                    [handler setEndDocumentTarget:self andAction:@selector(didFinishRegisterUser)];
                    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:request.responseData];
                    parser.delegate = handler;
                    [parser parse];
                //            }else if(request.responseStatusCode == 404){
                } else {
                    _user = nil;
                    [self didFinishRegisterUser];
                }
            }];
            [request setFailedBlock:^{
//                ASIHTTPRequest *request = weakRequest;
//                if (!request) return;
                [self handleError:request.error];
            }];
        
            [request startAsynchronous];
        }else {
            [repassword setText:@""];
            [repassword setPlaceholder:@"re-password does not match"];
        }
    }else {
        if ([trimSpaces([userName text]) length] == 0)
            [userName setText:@""];
        [userName setText:trimSpaces([userName text])];
        [userName setPlaceholder:@"User name is blank"];
        if ([trimSpaces([email text]) length] == 0) {
            [email setText:@""];
            [email setPlaceholder:@"Email is blank"];
        }else if(![NSStringUtil stringIsValidEmail:[email text]]){
            [email setText:@""];
            [email setPlaceholder:@"Email is not valid"];
        }
        if ([[password text] length] == 0)
            [password setPlaceholder:@"Password is blank"];
    }
}

- (void)handleError:(NSError*)error
{
    NSLog(@"Error receiving respone for login request: %@", error.localizedDescription);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *errorTitle;
    NSString *errorMessage;
    if ([error code] == 1) {
        errorTitle = @"Internet Access Problem";
        errorMessage = @"Please check your internet access!";
    } else {
        errorTitle = @"Error Ocurring";
        errorMessage = @"Unknown error";
    }
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:errorTitle
                                                             message:errorMessage
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [errorAlertView show];
}

#pragma mark - Text Fields Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    activeTextField = textField;
    if ([textField tag] == 1) {
        [textField setKeyboardType:UIKeyboardTypeDefault];
    }
    if ([textField tag] == 2) {
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
    [_parentController needToScroll:360];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_parentController needToScroll:0];
    return YES;
}

- (IBAction)dismissKeyboard{
    if (activeTextField != nil) {
        [activeTextField resignFirstResponder];
        [_parentController needToScroll:0];
    }
}

#pragma mark Application Service Delegate Methods
-(void) didFinishRegisterUser{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (_user != nil) {
        if (![_user.userId isEqualToString:@"-1"] && ![_user.userId isEqualToString:@"-2"]) {
            UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"Register Success"
                                                                       message:[NSString stringWithFormat:@"Welcome to Recipe"]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
            [successAlertView show];
            [_parentController.view setHidden:YES];
        } else if ([_user.userId isEqualToString:@"-1"]) {
            UIAlertView *failsAlertView = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                                     message:[NSString stringWithFormat:@"Username is not available"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
            [failsAlertView show];
        } else if ([_user.userId isEqualToString:@"-2"]) {
            UIAlertView *failsAlertView = [[UIAlertView alloc] initWithTitle:@"Register Failed"
                                                                     message:[NSString stringWithFormat:@"Email is not available"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
            [failsAlertView show];
        }
    }
}

@end
