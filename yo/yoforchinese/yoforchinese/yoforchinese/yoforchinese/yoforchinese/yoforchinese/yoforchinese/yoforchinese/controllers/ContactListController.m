//
//  ContactListController.m
//  yoforchinese
//
//  Created by NPHD on 14-8-1.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContactListController.h"
#import "APContact.h"
@interface ContactListController ()
{
    NSMutableArray *selectResult;
}
@end

@implementation ContactListController

- (id)initWithContacts :(NSArray*)acontacts  style:(UITableViewStyle)style :(void(^)(NSArray *results))aselectComplete;
{
    self = [super initWithStyle:style];
    if (self) {
        contacts = acontacts;
        complete = aselectComplete;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(0, 0, 80, 40);
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submit.frame = CGRectMake(0, 0, 80, 40);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:submit];
    self.navigationItem.rightBarButtonItem = right;
    
    selectResult = [[NSMutableArray alloc]init];
}
- (void)submit
{
    if(complete)
    {
        complete(selectResult);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    APContact *ap = [contacts objectAtIndex:indexPath.row];
    if([selectResult containsObject:ap])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [[[[ap.phones[0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByAppendingString:@"-"] stringByAppendingString:[ap.lastName==nil?@"":ap.lastName stringByAppendingString:ap.firstName==nil?@"":ap.firstName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectResult removeObject:[contacts objectAtIndex:indexPath.row]];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectResult addObject:[contacts objectAtIndex:indexPath.row]];
    }
}


@end
