//
//  ContactListController.m
//  yoforchinese
//
//  Created by NPHD on 14-8-1.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "ContactListController.h"
#import "APContact.h"
#import "pinyin.h"
@interface ContactListController ()
{
    NSMutableArray *selectResult;
    NSMutableDictionary *group;
    NSMutableArray *final;
}
@end

@implementation ContactListController

- (id)initWithContacts :(NSArray*)acontacts  style:(UITableViewStyle)style :(void(^)(NSArray *results))aselectComplete;
{
    self = [super initWithStyle:style];
    if (self) {
        contacts = acontacts;
        complete = aselectComplete;
        [self groupContacts];
    }
    return self;
}
- (int)getIndex :(NSString*)z
{
    if([z isEqualToString:@"a"]) return 0;
    if([z isEqualToString:@"b"]) return 1;
    if([z isEqualToString:@"c"]) return 2;
    if([z isEqualToString:@"d"]) return 3;
    if([z isEqualToString:@"e"]) return 4;
    if([z isEqualToString:@"f"]) return 5;
    if([z isEqualToString:@"g"]) return 6;
    if([z isEqualToString:@"h"]) return 7;
    if([z isEqualToString:@"i"]) return 8;
    if([z isEqualToString:@"j"]) return 9;
    if([z isEqualToString:@"k"]) return 10;
    if([z isEqualToString:@"l"]) return 11;
    if([z isEqualToString:@"m"]) return 12;
    if([z isEqualToString:@"n"]) return 13;
    if([z isEqualToString:@"o"]) return 14;
    if([z isEqualToString:@"p"]) return 15;
    if([z isEqualToString:@"q"]) return 16;
    if([z isEqualToString:@"r"]) return 17;
    if([z isEqualToString:@"s"]) return 18;
    if([z isEqualToString:@"t"]) return 19;
    if([z isEqualToString:@"u"]) return 20;
    if([z isEqualToString:@"v"]) return 21;
    if([z isEqualToString:@"w"]) return 22;
    if([z isEqualToString:@"x"]) return 23;
    if([z isEqualToString:@"y"]) return 24;
    if([z isEqualToString:@"z"]) return 25;
    if([z isEqualToString:@"#"]) return 26;
    return -1;
}
- (NSString*)getKey :(int)index
{
    if(index == 0) return @"a";
    if(index == 1) return @"b";
    if(index == 2) return @"c";
    if(index == 3) return @"d";
    if(index == 4) return @"e";
    if(index == 5) return @"f";
    if(index == 6) return @"g";
    if(index == 7) return @"h";
    if(index == 8) return @"i";
    if(index == 9) return @"j";
    if(index == 10) return @"k";
    if(index == 11) return @"l";
    if(index == 12) return @"m";
    if(index == 13) return @"n";
    if(index == 14) return @"o";
    if(index == 15) return @"p";
    if(index == 16) return @"q";
    if(index == 17) return @"r";
    if(index == 18) return @"s";
    if(index == 19) return @"t";
    if(index == 20) return @"u";
    if(index == 21) return @"v";
    if(index == 22) return @"w";
    if(index == 23) return @"x";
    if(index == 24) return @"y";
    if(index == 25) return @"z";
    if(index == 26) return @"#";
    return nil;
}
- (void)groupContacts
{
    if(!group)
        group = [[NSMutableDictionary alloc]init];
    for (APContact *ap in contacts)
    {
        NSString *name = [ap.lastName==nil?@"":ap.lastName stringByAppendingString:ap.firstName==nil?@"":ap.firstName];
        char z = '#';
        if(name.length > 0)
        {
            z = pinyinFirstLetter([name characterAtIndex:0]);
        }
        
        NSString *first =  [NSString stringWithFormat:@"%c",z];
        if([group objectForKey:first])
        {
            NSMutableArray *source = [group objectForKey:first];
            [source addObject:ap];
        }else
        {
            NSMutableArray *source = [[NSMutableArray alloc]initWithObjects:ap, nil];
            [group setObject:source forKey:first];
        }
        
        
    }
    int a[27] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
    for (NSString *key in [group keyEnumerator])
    {
        a[[self getIndex:key]] = [self getIndex:key];
    }
    final = [[NSMutableArray alloc]init];
    for (int i = 0; i != 27; i++)
    {
        if(a[i] != -1)
        {
            [final addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
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
    return group.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *index = [final objectAtIndex:section];
    NSString *key = [self getKey:[index integerValue]];
    return [[group objectForKey:key] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *index = [final objectAtIndex:section];
    NSString *key = [self getKey:[index integerValue]];
    return [key uppercaseString];
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
    NSString *index = [final objectAtIndex:indexPath.section];
    NSString *key = [self getKey:[index integerValue]];
    NSArray *cons = [group objectForKey:key];
    APContact *ap = [cons objectAtIndex:indexPath.row];
    if([selectResult containsObject:ap])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = [[[ap.lastName==nil?@"":ap.lastName stringByAppendingString:ap.firstName==nil?@"":ap.firstName] stringByAppendingString:@"-"] stringByAppendingString:[[ap.phones[0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *index = [final objectAtIndex:indexPath.section];
        NSString *key = [self getKey:[index integerValue]];
        NSArray *cons = [group objectForKey:key];
        [selectResult removeObject:[cons objectAtIndex:indexPath.row]];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *index = [final objectAtIndex:indexPath.section];
        NSString *key = [self getKey:[index integerValue]];
        NSArray *cons = [group objectForKey:key];
        [selectResult addObject:[cons objectAtIndex:indexPath.row]];
    }
}


@end
