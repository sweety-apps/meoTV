//
//  ImageController.h
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentView.h"

@interface ImageController : UIViewController<ContentViewInterface> {
    NSString* _filePath;
}

@property (nonatomic, retain) IBOutlet UIImageView* _imageView;

- (UIView*) getView;
@end
