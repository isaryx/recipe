//
//  RecipeViewController.m
//  recipe
//
//  Created by Vu Tran on 3/28/12.
//  Copyright 2012 Perselab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RecipeViewController.h"
#import "GlobalStore.h"
#import "NSStringUtil.h"
#import "IngredientsTableViewController.h"
#import "StepsTableViewController.h"
#import "ASI2HTTPRequest.h"
#import "RecipeDisclosureIndicators.h"
#import "AddRecipeViewController.h"
#import "HJManagedImageV.h"

@implementation RecipeViewController
@synthesize pageControl;
@synthesize recipeDetailsTable;
@synthesize recipe = _recipe;
@synthesize slideShowCell;
@synthesize recipeHeaderView;
@synthesize recipeInfoView;
@synthesize recipeNameLabel;
@synthesize recipeLikeCount;
@synthesize userInfoCell;
@synthesize userThumb;
@synthesize borderThumb;
@synthesize userName;
@synthesize timeSpanSinceCreated;
@synthesize imageSlider;
@synthesize defaultRecipeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self.navigationItem setTitle:@"Missing Recipe Name"];
    }
    return self;
}

- (id)initWithEditableRecipe{
    self = [super initWithNibName:@"RecipeViewController" bundle:nil];
    if (self) {
        editable = YES;
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

- (void)viewWillAppear:(BOOL)animated
{
    if (isNeedToRefresh) {
        [[self recipeDetailsTable] reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Uncomment for allowing edit recipe
//    if (editable || [[[[GlobalStore sharedStore] loggedUser] userId] isEqualToString:[[[self recipe] owner] userId]]) {
//        barButton = [[UIBarButtonItem alloc] 
//                     initWithTitle:@"Edit"                                            
//                     style:UIBarButtonItemStyleBordered 
//                     target:self 
//                     action:@selector(editRecipe:)];
//        self.navigationItem.rightBarButtonItem = barButton;
//    }
    
    [[self pageControl] setHidesForSinglePage:YES];
    [self.recipeDetailsTable setBackgroundColor:[UIColor clearColor]];
    [[self recipeNameLabel] setText:[[self recipe] name]];
    [[self userName] setText:[[[self recipe] owner] name]];
    [[self timeSpanSinceCreated] setText:[NSStringUtil formatDate:[[self recipe] createDate] usingFormat:@"yyyy-MM-dd"]];
    [[self recipeLikeCount] setText:[NSString stringWithFormat:@"%d", [[self recipe] likeCount]]];
    [[[self userThumb] layer] setCornerRadius:8.0];
    [[[self userThumb] layer] setMasksToBounds:YES];
    [[[self borderThumb] layer] setCornerRadius:8.0];
    [[[self borderThumb] layer] setMasksToBounds:YES];
    [[[self defaultRecipeView] layer] setCornerRadius:11.0];
    [[self defaultRecipeView] setClipsToBounds:YES];
    [self loadImageSlider];
    [self loadUserAvatar];
}

- (void)viewDidUnload
{
    [self setRecipeDetailsTable:nil];
    [self setSlideShowCell:nil];
    [self setRecipeNameLabel:nil];
    [self setRecipeHeaderView:nil];
    [self setRecipeInfoView:nil];
    [self setRecipeLikeCount:nil];
    [self setUserThumb:nil];
    [self setUserName:nil];
    [self setTimeSpanSinceCreated:nil];
    [self setUserInfoCell:nil];
    [self setImageSlider:nil];
    [self setBorderThumb:nil];
    [self setPageControl:nil];
    [self setDefaultRecipeView:nil];
    [super viewDidUnload];
}

- (void)editRecipe:(id)sender{
    AddRecipeViewController *viewControllerToPush = [[AddRecipeViewController alloc] initWithNibName:@"AddRecipeViewController" bundle:nil];
    [[viewControllerToPush navigationItem] setTitle:@"Edit Recipe"];
    [viewControllerToPush setRecipe:[self recipe]];
    [[self navigationController] pushViewController:viewControllerToPush animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadUserAvatar
{
    if (![[[[self recipe] owner] avatarId] isEqualToString:@"-1"]) {
        NSURL *url = [[NSURL alloc] initWithString:[GlobalStore imageLinkWithImageId:[[[self recipe] owner] avatarId] forWidth:100 andHeight:0]];
        
        __weak __block ASI2HTTPRequest *request = [ASI2HTTPRequest requestWithURL:url];
        [request setCompletionBlock:^{
            NSData *data = request.responseData;
            [userThumb setImage:[[UIImage alloc] initWithData:data]];
        }];
        [request setFailedBlock:^{
            NSError *error = request.error;
            NSLog(@"Error downloading image: %@", error.localizedDescription);
        }];
        [request startAsynchronous];
    }
}

- (void)loadImageSlider
{
    NSInteger count = [[[self recipe] imageList] count];
    [[self pageControl] setNumberOfPages:count];
    CGFloat w = 300.00f;
    CGFloat y = 0.00f;
    CGFloat sx = 0.00f;
    if (count > 0) {
        for (NSInteger i = 0; i < count; i++) {
            HJManagedImageV *image = [[HJManagedImageV alloc] initWithFrame:CGRectMake(sx,y,w,200)];
            [[image layer] setCornerRadius:10];
            [[image layer] setMasksToBounds:YES];
            [imageSlider addSubview:image];

            image.url = [[NSURL alloc] initWithString:[GlobalStore imageLinkWithImageId:[[[self recipe] imageList] objectAtIndex:i] forWidth:600 andHeight:400]];
            
//            __block ASI2HTTPRequest *request = [ASI2HTTPRequest requestWithURL:url];
//            [request setCompletionBlock:^{
//                NSData *data = request.responseData;
//                [image setImage:[[UIImage alloc] initWithData:data]];
//                //[[NSNotificationCenter defaultCenter] postNotificationName:@"com.razeware.imagegrabber.imageupdated" object:self];
//            }];
//            [request setFailedBlock:^{
//                NSError *error = request.error;
//                NSLog(@"Error downloading image: %@", error.localizedDescription);
//            }];
//            [request startAsynchronous];
            
            [[[GlobalStore sharedStore] objectManager] manage:image];
            sx += w;
        }
    }
    
    [imageSlider setContentSize:CGSizeMake(sx, 200.00f)];
    [imageSlider setPagingEnabled:YES];
    [imageSlider setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

#pragma mark Scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = imageSlider.frame.size.width;
    int page = floor((imageSlider.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    CGRect frame = imageSlider.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [imageSlider scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

#pragma mark Table delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
//    if ([[[self recipe] ingredientList] count] == 0 && [[[self recipe] stepList] count] == 0) {
//        return 2;
//    }
//    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 40.00f;
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return [self recipeInfoView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    else if (section == 2){
        return 2;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 40.0;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 201.0;
    }
    else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCell = @"User";
    static NSString *imageCell = @"Image";
    static NSString *listCell = @"List";
    if (indexPath.section == 0) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:userCell];
        if (cell == nil) {
            cell = userInfoCell;
        }
        
        [cell setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:imageCell];
        if (cell == nil) {
            cell = slideShowCell;
        }
    
        [cell setBackgroundView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        return cell;
    }
    else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:listCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCell];
        }
        if (indexPath.row == 0) {
            if ([[[self recipe] ingredientList] count] == 1 || [[[self recipe] ingredientList] count] == 0) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%d Ingredient", [[[self recipe] ingredientList] count]]];
            } else {
                [cell.textLabel setText:[NSString stringWithFormat:@"%d Ingredients", [[[self recipe] ingredientList] count]]];
            }
            ingredientTitleText = cell.textLabel.text;
        }
        else {
            if ([[[self recipe] stepList] count] == 1 || [[[self recipe] stepList] count] == 0) {
                [cell.textLabel setText:[NSString stringWithFormat:@"%d Step", [[[self recipe] stepList] count]]];
            } else {
                [cell.textLabel setText:[NSString stringWithFormat:@"%d Steps", [[[self recipe] stepList] count]]];
            }
            stepTitleText = cell.textLabel.text;
        }
        
        RecipeDisclosureIndicators *accessory = [RecipeDisclosureIndicators accessoryWithColor:[UIColor colorWithRed:0.76f green:0.54f blue:0.29f alpha:1.00f]];
        [accessory setHighlightedColor:[UIColor orangeColor]];
        [cell setAccessoryView:accessory];
        [[cell textLabel] setTextColor:[UIColor colorWithRed:0.76f green:0.54f blue:0.29f alpha:1.00f]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if ([[[self recipe] ingredientList] count] > 0 || [[[[GlobalStore sharedStore] loggedUser] userId] isEqualToString:[[[self recipe] owner] userId]]){
                isNeedToRefresh = YES;
                IngredientsTableViewController *viewControllerToPush = [[IngredientsTableViewController alloc] initWithNibName:@"IngredientsTableViewController" bundle:nil];
                [viewControllerToPush.navigationItem setTitle:ingredientTitleText];
                [viewControllerToPush setRecipe:[self recipe]];
                [self.navigationController pushViewController:viewControllerToPush animated:YES];
            }
        } else if (indexPath.row == 1){
            if ([[[self recipe] stepList] count] > 0 || [[[[GlobalStore sharedStore] loggedUser] userId] isEqualToString:[[[self recipe] owner] userId]]){
                isNeedToRefresh = YES;
                StepsTableViewController *viewControllerToPush = [[StepsTableViewController alloc] initWithNibName:@"StepsTableViewController" bundle:nil];
                [viewControllerToPush.navigationItem setTitle:stepTitleText];
                [viewControllerToPush setRecipe:[self recipe]];
                [self.navigationController pushViewController:viewControllerToPush animated:YES];
            }
        }
    }
}

@end
