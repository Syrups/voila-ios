//
//  SettingsViewController.m
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserSession.h"
#import "Cache.h"
#import "UserManager.h"
#import "Configuration.h"
#import "UIImageView+WebCache.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableViewController* tableController = (UITableViewController*)self.childViewControllers[0];
    self.settingsTableView = tableController.tableView;
    self.settingsTableView.delegate = self;
    
    self.user = [Cache cachedUser];
    
    if (self.user == nil) {
        UserManager* manager = [[UserManager alloc] init];
        [manager getUser:[[UserSession sharedSession] user] withSuccess:^(User *user) {
            self.user = user;
            [self updateView];
        } failure:^{
            // ERROR
        }];
    } else {
        [self updateView];
    }

}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.menu.masterViewController.navigationController setViewControllers:@[vc] animated:YES];
}

- (void)updateView {
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        [self logout:nil];
    }
    
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"ToWebview" sender:nil];
    }
    
    if (indexPath.row == 2) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Souhaitez-vous vraiment supprimer vos données et votre compte ? Cette action est irréversible" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Confirmer", nil];
        [alert show];
    }
    
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"ToAvatarSegue" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UILabel* username = (UILabel*)[cell.contentView viewWithTag:10];
        username.text = self.user.username;
    }
    
    if (indexPath.row == 1) {
        UIImageView* avatar = (UIImageView*)[cell.contentView viewWithTag:10];
        if (self.user.avatar != nil) [avatar sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.user.avatar)]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 68;
    }
    
    return 45;
}

- (void)confirmAccountDelete {
    UserManager* manager = [[UserManager alloc] init];
    UserSession* session = [UserSession sharedSession];
    
    [manager deleteAccountOfUser:[session user] success:^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Données supprimées" message:@"Vos données ont bien été effacées" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        alert.tag = 2;
        [alert show];
        
        // reset app storyboard
        [self.menu close:nil];
        UINavigationController* nav = [self.storyboard instantiateInitialViewController];
        [nav setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"Login"]]];
    } failure:^{
        ErrorAlert(@"Votre compte n'a pas pu être supprimé en raison d'une erreur, rééssayez dans quelques instants.");
    }];
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // first alert
    if (buttonIndex == 1 && alertView.tag == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Votre compte, les services reçus et proposés à vos amis seront définitivement supprimés. Etes-vous certain ?" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Oui, supprimer", nil];
        alert.tag = 1;
        [alert show];
    }
    
    // second alert
    if (buttonIndex == 1 && alertView.tag == 1) {
        [self confirmAccountDelete];
    }
}

@end
