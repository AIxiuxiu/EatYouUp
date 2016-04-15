//
//  SocaialManager.h
//  Eating
//
//  Created by System Administrator on 12/15/14.
//  Copyright (c) 2014 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocaialManager : NSObject

+ (SocaialManager *)sharedManager;

- (void)showNewUIShareOnVC:(id)sender
                   Content:(NSString *)content
                  UserName:(NSString*)uname
                  WorkName:(NSString *)work
                    Images:(UIImage *)images
                 ImagesUrl:(NSURL *)url;

- (void)shareToWechatTimelineWithFeedID:(NSString *)feedID
                                Content:(NSString *)content
                               UserName:(NSString *)uname
                               WorkName:(NSString *)work
                                 Images:(UIImage *)images
                                Success:(void (^)(BOOL))success;

- (void)shareToWechatSessionWithFeedID:(NSString *)feedID
                               Content:(NSString *)content
                              UserName:(NSString *)uname
                              WorkName:(NSString *)work
                                Images:(UIImage *)images
                               Success:(void (^)(BOOL))success;

@end
