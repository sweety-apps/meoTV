//
//  UIMovieViewController.m
//  Test
//
//  Created by NPHD on 14-4-28.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import "UIMovieViewController.h"
#import "NSMovieMgr.h"
#import "UIMovieViewCell.h"

@interface UIMovieViewController ()

@end

@implementation UIMovieViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        scrollPos = 0;
        clickPos = -100;
        curDisplay = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerActive:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[NSMovieMgr sharedInstance] getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UIMovieViewCell";
    UIMovieViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UIMovieViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    if ( cell ) {
        MovieInfo* info = [[NSMovieMgr sharedInstance] getMovieInfo:indexPath.row];
        [cell setMovieInfo:info];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 340;
}

- (void) timerActive:(NSTimer*) timer {
    CGPoint pt = self.tableView.contentOffset;
    if ( clickPos == pt.y ) {
        return ;
    }
    
    if ( ABS(pt.y - scrollPos) < 1 ) {
        // 获取可以播放的项
        int nIndex = (int)((pt.y + 240)/ 340);
        
        if ( [[NSMovieMgr sharedInstance] getCount] > nIndex ) {
            MovieInfo* info = [[NSMovieMgr sharedInstance] getMovieInfo:nIndex];
            if ( [info isEqual:curDisplay] ) {
                // 已经在播放中,什么也不做
            } else if ( curDisplay == nil ) {
                // 直接播放
                [info play];
                curDisplay = info;
            } else {
                // 已经有在播放的了
                [curDisplay stop];
                [info play];
                curDisplay = info;
            }
        }
    }
    
    scrollPos = pt.y;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    clickPos = self.tableView.contentOffset.y;
    
    // 获取可以播放的项
    int nIndex = indexPath.row;
        
    if ( [[NSMovieMgr sharedInstance] getCount] > nIndex ) {
        MovieInfo* info = [[NSMovieMgr sharedInstance] getMovieInfo:nIndex];
        if ( [info isEqual:curDisplay] ) {
            // 已经在播放中,什么也不做
            if ( info.status == MovieInfoStatusPause ) {
                [info play];
            } else if ( info.status == MovieInfoStatusPlaying ) {
                [info pause];
            }
        } else if ( curDisplay == nil ) {
            // 直接播放
            [info play];
            curDisplay = info;
        } else {
            // 已经有在播放的了
            [curDisplay stop];
            [info play];
            curDisplay = info;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
