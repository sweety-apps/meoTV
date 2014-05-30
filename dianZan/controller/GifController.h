//
//  GifController.h
//  dianZan
//
//  Created by NPHD on 14-5-29.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentView.h"
#import "SCGIFImageView.h"

@interface GifController : UIViewController<ContentViewInterface> {
    SCGIFImageView* _imageView;
    NSString*       _filePath;
}


- (UIView*) getView;
@end
