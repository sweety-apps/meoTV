//
//  WebImageView.h
//  meoTV
//
//  Created by NPHD on 14-5-6.
//  Copyright (c) 2014年 NPHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLRequest.h>

@interface ImageViewCache : NSObject {
    
}

@property (nonatomic,retain) NSMutableData* _mutdata;
@property (nonatomic,retain) NSURLConnection* _connect;
@property (nonatomic,retain) NSString*   _imageFile;

@end


@interface UIImageView (WebImageView) <NSURLConnectionDataDelegate> {
}

- (void) cancelLoadImage;
- (void) setImageWithURL:(NSString*) url cacheFile:(NSString*) fileName forever:(BOOL) fe;

@end
