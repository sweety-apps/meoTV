//
//  ViewController.m
//  Example
//
//  Created by Illya Busigin  on 7/19/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import "PublishViewController.h"
#import "NaviItems.h"
#import "SelectView.h"
#import "KSDImageResize.h"
#import "KSDShotScreen.h"
#import "ZYQAssetPickerController.h"
#import "KSDIMStatus.h"
#import "MBProgressHUD.h"
#define kImageSize  60.f
@interface PublishViewController () <UITextViewDelegate>
{
    NSMutableArray *images;
    UIButton *btn;
    MBProgressHUD *hud;
}
@property (nonatomic, strong) NSMutableArray *keyboardButtons;
@property (nonatomic, strong) UIInputView *numberView;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PublishViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    self.textView.font = [UIFont systemFontOfSize:13.f];
    [self.scrollView addSubview:self.textView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 0.5f)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:line];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [NaviItems naviRightBtnWithTitle:@"发表" target:self selector:@selector(publish)];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 110, kImageSize, kImageSize);
    [btn setBackgroundImage:[UIImage imageNamed:@"AddGroupMemberBtn"] forState:UIControlStateNormal];
    [self.scrollView addSubview:btn];
    [btn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)publish
{
    [self.textView resignFirstResponder];
    hud = [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    hud.labelText = @"正在发送...";
    double timesp = [[NSDate date] timeIntervalSince1970];
    [[KSDIMStatus sharedClient] POST:@"/createweibo" parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.textView.text,@"content",[NSString stringWithFormat:@"%f",timesp],@"createTime" ,nil] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for (UIImage *img in images)
        {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 1.f) name:[NSString stringWithFormat:@"%d",i] fileName:@"x.jpg" mimeType:@"image/jpeg"];
            i++;
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *retinfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"publishSuccess" object:retinfo];
        [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Constraint Management

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:textView action:@selector(resignFirstResponder)];
    
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

#pragma mark - UIKeyboard

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
        [cameraContainer setFullScreenMode];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];

    }else if(buttonIndex == 1)
    {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 6-images.count;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }else if(buttonIndex == 2)
    {
        
    }
}
- (void)photo
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.scrollView];
    
    
}
- (void)cancel
{
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    if ([self.textView isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration animations:^{
           
        } completion:^(BOOL finished) {
            
//            PublishViewController __weak *tmp = self;
//            selectView = [[SelectView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-kbSize.height-40, [[UIScreen mainScreen] bounds].size.width, 40)];
//            [selectView setPhotnAction:^{
//                DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:tmp];
//                [cameraContainer setFullScreenMode];
//                
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
//                [nav setNavigationBarHidden:YES];
//                [tmp presentViewController:nav animated:YES completion:nil];
//            }];
//            [selectView setCancelAction:^{
//                [tmp.textView resignFirstResponder];
//            }];
//            [self.view addSubview:selectView];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if ([self.textView isFirstResponder]) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:duration animations:^{
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - 相机委托
- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
     [cameraViewController dismissViewControllerAnimated:YES completion:nil];
    if(!images)
    {
        images = [[NSMutableArray alloc]init];
    }
    [images addObject:image];
    double shortLine = image.size.height>image.size.width?image.size.width:image.size.height;
    UIImage *cutimage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake((image.size.width-shortLine)/2.f, (image.size.height-shortLine)/2.f, shortLine, shortLine))];
    
    
    UIImageView *c = [[UIImageView alloc]initWithImage:cutimage];
    c.frame = CGRectMake(0, 0, kImageSize, cutimage.size.height/(cutimage.size.width/kImageSize));
    if(images.count < 4)
    {
        c.frame = CGRectMake(10+(images.count-1)*(kImageSize+10), 110, kImageSize, kImageSize);
        btn.frame =CGRectMake(10+(images.count)*(kImageSize+10), btn.frame.origin.y, kImageSize, kImageSize);    }else
    {
        if(images.count == 4)
        {
            btn.frame = CGRectMake(10, btn.frame.origin.y+btn.frame.size.height+10, kImageSize, kImageSize);
            c.frame = CGRectMake(10+(images.count-1)*(kImageSize+10), 110, kImageSize, kImageSize);
        }else
        {
            if(images.count == 6)
            {
                [btn removeFromSuperview];
            }else
            {
                btn.frame = CGRectMake(10+(images.count-4)*(kImageSize+10), 10+kImageSize+110, kImageSize, kImageSize);;
                
            }
            c.frame = CGRectMake(10+(images.count-5)*(kImageSize+10), 10+kImageSize+110, kImageSize, kImageSize);
            
        }
    }
    
    [self.scrollView addSubview:c];
//
}

/**
 *  Tells the delegate when the camera must be dismissed
 */
- (void) dismissCamera:(id)cameraViewController
{
    [cameraViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        double shortLine = image.size.height>image.size.width?image.size.width:image.size.height;
        UIImage *cutimage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(asset.defaultRepresentation.fullResolutionImage, CGRectMake((image.size.width-shortLine)/2.f, (image.size.height-shortLine)/2.f, shortLine, shortLine))];
        
        UIImageView *c = [[UIImageView alloc]initWithImage:cutimage];
        c.frame = CGRectMake(0, 0, 60, cutimage.size.height/(cutimage.size.width/60.f));
        
        if(!images)
        {
            images = [[NSMutableArray alloc]init];
        }
         [images addObject:image];
        if(images.count < 4)
        {
            c.frame = CGRectMake(10+(images.count-1)*(kImageSize+10), 110, kImageSize, kImageSize);
            btn.frame =CGRectMake(10+(images.count)*(kImageSize+10), btn.frame.origin.y, kImageSize, kImageSize);
        }else
        {
                if(images.count == 4)
                {
                    btn.frame = CGRectMake(10, btn.frame.origin.y+btn.frame.size.height+10, kImageSize, kImageSize);
                    c.frame = CGRectMake(10+(images.count-1)*(kImageSize+10), 110, kImageSize, kImageSize);
                }else
                {
                    if(images.count == 6)
                    {
                        [btn removeFromSuperview];
                    }else
                    {
                        btn.frame = CGRectMake(10+(images.count-4)*(kImageSize+10), 10+kImageSize+110, kImageSize, kImageSize);;
                       
                    }
                     c.frame = CGRectMake(10+(images.count-5)*(kImageSize+10), 10+kImageSize+110, kImageSize, kImageSize);
                    
                }
            }
        
        [self.scrollView addSubview:c];

    }
}

@end
