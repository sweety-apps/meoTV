//
//  ViewController.h
//  Example
//
//  Created by Illya Busigin  on 7/19/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCameraContainerViewController.h"
#import "ZYQAssetPickerController.h"
@interface PublishViewController : UIViewController<DBCameraViewControllerDelegate,ZYQAssetPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@end
