//
//  ContentViewController.m
//  youLost
//
//  Created by 1528 MAC on 14-9-4.
//  Copyright (c) 2014年 ksd. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentItem.h"
#import "UIImageView+WebCache.h"
#import "KSDImageResize.h"
#import "KSDPhotoViewLayout.h"
#import "UILabel+autoFit.h"
#import "KSDShotScreen.h"
#import "KSDPhotoViewLayout.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "NaviItems.h"
#import "MJRefresh.h"
#import "PublishViewController.h"
#import "KSDIMStatus.h"
#define kLeftPading 50
#define kTopPading 30
#define kBottomPading 30
#define kTextImagePAding 10
#define kImagePading 5
#define kImageHeight 60
#define kItemCount 10

@interface ContentViewController ()
{
    NSMutableDictionary *lays;
}
@property(nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]init];
    lays = [[NSMutableDictionary alloc]init];
    [self setupRefresh];
    self.title = @"首页";
    
    self.navigationItem.rightBarButtonItem = [NaviItems naviRightBtnWithTitle:@"发表" target:self selector:@selector(publish)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"publishSuccess" object:nil];
    

}
- (void)refresh:(NSNotification*)noti
{
    [self.tableView headerBeginRefreshing];
//    NSDictionary *retinfo = [noti object];
//    NSLog(@"%@",retinfo);
//    NSDictionary *weibo = [[retinfo objectForKey:@"data"] objectForKey:@"weibo"];
//    
//        
//        ContentItem *item3 = [[ContentItem alloc]init];
//        item3.desc = [weibo objectForKey:@"desc"];
//        item3.name = [[weibo objectForKey:@"user"] objectForKey:@"nickName"];
//        item3.avatarURLStr = [[weibo objectForKey:@"user"] objectForKey:@"avatar"];
//        item3.images = [weibo objectForKey:@"images"];
//        item3.createTime = [NSDate dateWithTimeIntervalSince1970:[[weibo objectForKey:@"createTime"] doubleValue]];
//        [self.dataSource addObject:item3];
//        
//    
//    [self.tableView reloadData];
}
- (void)publish
{
    [self.navigationController pushViewController:[[PublishViewController alloc]init] animated:YES];
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"正在刷新中";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    self.tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    self.tableView.footerRefreshingText = @"正在帮你加载";
}
- (void)headerRereshing
{
    
   
    [[KSDIMStatus sharedClient] POST:@"/fetchweibo" parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"datafrom",[NSString stringWithFormat:@"%d",kItemCount],@"dataend",nil] success:^(NSURLSessionDataTask *task, id responseObject) {
         [self.dataSource removeAllObjects];
        NSDictionary *retinfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        BOOL isReload = NO;
        for (NSDictionary *weibo in [[retinfo objectForKey:@"data"] objectForKey:@"weibos"])
        {
            
            ContentItem *item3 = [[ContentItem alloc]init];
            item3.desc = [weibo objectForKey:@"desc"];
            item3.name = [[weibo objectForKey:@"user"] objectForKey:@"nickName"];
            item3.avatarURLStr = [[weibo objectForKey:@"user"] objectForKey:@"avatar"];
            item3.images = [weibo objectForKey:@"images"];
             item3.createTime = [NSDate dateWithTimeIntervalSince1970:[[weibo objectForKey:@"createTime"] doubleValue]];
            [self.dataSource addObject:item3];
            isReload = YES;
            
        }
        if(isReload)
        {
           [self.tableView reloadData];
        }
        
        [self.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView headerEndRefreshing];
    }];
}

- (void)footerRereshing
{
    [[KSDIMStatus sharedClient] POST:@"/fetchweibo" parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",(unsigned long)self.dataSource.count],@"datafrom",[NSString stringWithFormat:@"%d",kItemCount],@"dataend",nil] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *retinfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        BOOL isReload = NO;
        for (NSDictionary *weibo in [[retinfo objectForKey:@"data"] objectForKey:@"weibos"])
        {
            
            ContentItem *item3 = [[ContentItem alloc]init];
            item3.desc = [weibo objectForKey:@"desc"];
            item3.name = [[weibo objectForKey:@"user"] objectForKey:@"nickName"];
            item3.avatarURLStr = [[weibo objectForKey:@"user"] objectForKey:@"avatar"];
            item3.images = [weibo objectForKey:@"images"];
            item3.createTime = [NSDate dateWithTimeIntervalSince1970:[[weibo objectForKey:@"createTime"] doubleValue]];
            [self.dataSource insertObject:item3 atIndex:self.dataSource.count];
            isReload = YES;
            
        }
        if(isReload)
        {
             [self.tableView reloadData];
        }
        [self.tableView footerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView footerEndRefreshing];
    }];
    
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
    return self.dataSource.count;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
- (CGFloat)getHetght :(int)row
{
    ContentItem *item = [self.dataSource objectAtIndex:row];
    CGSize labelSize = [item.desc sizeWithFont:[UIFont systemFontOfSize:12.f]
                             constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-kLeftPading, 100)
                                 lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize createTimeSize = [[self stringFromDate:item.createTime] sizeWithFont:[UIFont systemFontOfSize:13.f]
                                                              constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-kLeftPading, 100)
                                                                  lineBreakMode:UILineBreakModeCharacterWrap];
    
    double offset = createTimeSize.height+5;
    if(item.images.count == 0)
    {
        return kBottomPading+labelSize.height+kTextImagePAding;
    }else if(item.images.count <=3)
    {
        return kBottomPading+labelSize.height+kImageHeight+kTextImagePAding+2*kImagePading+offset;
    }else if(item.images.count<=6)
    {
        return kBottomPading+labelSize.height+2*kImageHeight+kTextImagePAding+3*kImagePading+offset;
    }else if(item.images.count <=9)
    {
        return kBottomPading+labelSize.height+3*kImageHeight+kTextImagePAding+4*kImagePading+offset;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHetght:indexPath.row];
   
}
- (UILabel*)createDesc:(NSString*)str :(UIFont*)font
{
    CGSize labelSize = [str sizeWithFont:font
                       constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-kLeftPading, 100)
                           lineBreakMode:UILineBreakModeCharacterWrap];   // str是要显示的字符串
    UILabel *patternLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftPading, kTopPading, labelSize.width, labelSize.height)];
    patternLabel.text = str;
    patternLabel.backgroundColor = [UIColor clearColor];
    patternLabel.font = font;
    patternLabel.numberOfLines = 0;// 不可少Label属性之一
    patternLabel.lineBreakMode = UILineBreakModeCharacterWrap;// 不可少Label属性之二
    return patternLabel;
}- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"ContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ContentItem *item = [self.dataSource objectAtIndex:indexPath.row];
    KSDPhotoViewLayout *photoLayout =  [[KSDPhotoViewLayout alloc]initWithContent:item cell:cell];
    [photoLayout layout];
    [photoLayout setSelectImage:^(ContentItem *item, int imageIndex) {
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity: item.images.count];
        for (int i = 0; i < item.images.count; i++) {
            // 替换为中等尺寸图片
            NSString * getImageStrUrl = [NSString stringWithFormat:@"%@", [item.images objectAtIndex:i]];
            getImageStrUrl = [[getImageStrUrl componentsSeparatedByString:@"_"][0] stringByAppendingString:@".jpg"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString: getImageStrUrl ]; // 图片路径
            
           // UIImageView * imageView = (UIImageView *)[self.view viewWithTag: imageTap.view.tag ];
           // photo.srcImageView = imageView;
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = imageIndex; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }];
    [lays setValue:photoLayout forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *createDate = [self stringFromDate:item.createTime];
    UILabel *createDateLabel = [self createDesc:createDate :[UIFont systemFontOfSize:14.f]];
    createDateLabel.textColor = [UIColor lightGrayColor];
    CGRect frame = createDateLabel.frame;
    frame.origin.x = [[UIScreen mainScreen] bounds].size.width-frame.size.width-10;
    frame.origin.y = [self getHetght:indexPath.row]-frame.size.height-5;
    createDateLabel.frame = frame;
    [cell.contentView addSubview:createDateLabel];
    return cell;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
