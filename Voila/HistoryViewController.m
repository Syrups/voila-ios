//
//  HistoryViewController.m
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "HistoryViewController.h"
#import "PropositionManager.h"
#import "UserSession.h"
#import "User.h"
#import "PKAIDecoder.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outbox = [OutboxManager sharedManager];
    self.outbox.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self.historyTableView addSubview:self.refreshControl];
    
    PropositionManager* manager = [[PropositionManager alloc] init];
    [manager getSentPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *sent) {
        self.sent = sent;
        [self.historyTableView reloadData];
    } failure:^{
        //ERROR
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refresh {
    PropositionManager* manager = [[PropositionManager alloc] init];
    User* user = [[UserSession sharedSession] user];
    [manager clearCacheForSentPropositionsForUser:user];
    [manager getSentPropositionsOfUser:user success:^(NSArray *sent) {
        self.sent = sent;
        [self.historyTableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^{
        //ERROR
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.outbox.pendingShipments.count;
    }
    
    return self.sent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.outbox.pendingShipments.count) {
        return [self cellForSentPropositionAtIndexPath:indexPath];
    }
    
    return [self cellForOutboxPendingShipmentAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.outbox.pendingShipments.count) {
        
        UIView* sending = [[[NSBundle mainBundle] loadNibNamed:@"Sending" owner:self options:nil] objectAtIndex:0];
        sending.frame = self.view.frame;
        
        UIImageView* loaderImage = (UIImageView*)[sending.subviews objectAtIndex:0];
        [PKAIDecoder builAnimatedImageIn:loaderImage fromFile:@"loader"];
        
        [self.view addSubview:sending];
        
        self.sending = sending;
        
        [self.outbox attemptSendPropositionAtIndex:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

#pragma mark - Cell helpers

- (UITableViewCell*)cellForOutboxPendingShipmentAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self.historyTableView dequeueReusableCellWithIdentifier:@"HistoryPendingCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryPendingCell"];
    }
    
    NSDictionary* data = [self.outbox.pendingShipments objectAtIndex:indexPath.row];
    
    UIImageView* image =  (UIImageView*)[cell.contentView viewWithTag:10];
    image.image = [data objectForKey:@"image"];
    
    UIButton* cancel = (UIButton*)[cell.contentView viewWithTag:40];
    
    [cancel addTarget:self action:@selector(cancelShipment:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCell*)cellForSentPropositionAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self.historyTableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"];
    }
    
    Proposition* proposition = [self.sent objectAtIndex:(indexPath.row+self.outbox.pendingShipments.count)];
    
    UIImageView* image =  (UIImageView*)[cell.contentView viewWithTag:10];
    [image sd_setImageWithURL:[NSURL URLWithString:MediaUrl(proposition.image)]];
    
    UILabel* receiverNames = (UILabel*)[cell.contentView viewWithTag:20];
    
    if (proposition.receivers.count > 0)
        receiverNames.text = [self receiversLabelForReceivers:proposition.receivers];
    
    UILabel* timeLabel = (UILabel*)[cell.contentView viewWithTag:30];
    timeLabel.text = [self timeLabelForProposition:proposition];
    
    return cell;
}

- (void)cancelShipment:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.historyTableView];
    NSIndexPath *indexPath = [self.historyTableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.row >= self.outbox.pendingShipments.count) return;
    
    [self.outbox.pendingShipments removeObjectAtIndex:indexPath.row];
    
    [self.historyTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - OutboxManager

- (void)outboxManager:(OutboxManager *)manager didSucceedSendingPropositionAtIndex:(NSUInteger)index {
    [manager.pendingShipments removeObjectAtIndex:index];
    [self.historyTableView reloadData];
    [self.sending removeFromSuperview];
}

- (void)outboxManager:(OutboxManager *)manager didFailSendingPropositionAtIndex:(NSUInteger)index {
    [self.sending removeFromSuperview];
}

#pragma mark - Helpers

- (NSString*)receiversLabelForReceivers:(NSArray*)receivers {
    NSMutableString* label = [NSMutableString stringWithFormat:@"%@", ((User*)receivers[0]).username];
    
    if (receivers.count > 1) {
        [label appendString:[NSString stringWithFormat:@" et %ld autres", receivers.count-1]];
    }
    
    return label;
}

- (NSString*)timeLabelForProposition:(Proposition*)proposition {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    
    NSDate *now = [NSDate date];
    NSDate *created = [formatter dateFromString:proposition.sentAt];
    
    NSTimeInterval diff = [now timeIntervalSinceDate:created];
    
    NSString* dateText;
    
    if (diff < 60) {
        dateText = @"Just now";
    } else if (diff < 3600) {
        dateText = [NSString stringWithFormat:@"Il y a %d minutes", (int)(diff / 60)];
    } else if (diff < 86400) {
        int h = (int) (diff / 3600);
        dateText = [NSString stringWithFormat:@"Il y a %d heures", h];
    } else if (diff > 86400 && diff < 172800) {
        dateText = [NSString stringWithFormat:@"Hier"];
    } else {
        dateText = [NSString stringWithFormat:@"Il y a %d jours", (int)(diff / 86400)];
    }
    
    return dateText;
}

@end
