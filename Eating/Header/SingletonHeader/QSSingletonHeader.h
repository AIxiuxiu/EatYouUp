//
//  QSSingletonHeader.h
//  Eating
//
//  Created by ysmeng on 14/12/2.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#ifndef Eating_QSSingletonHeader_h
#define Eating_QSSingletonHeader_h

//单例h文件宏
#define CREATE_SINGLETON_HEADER(className) + (instancetype)shared##className;

//实现宏
#if __has_feature(objc_arc)

//***************不是ARC***************//
    #define CREATE_SINGLETON_WITHCLASSNAME(className)\
\
static className *shared##className = nil;\
+ (instancetype)shared##className {\
\
    return [[self alloc] init];\
\
}\
\
- (instancetype)init\
{\
\
    if (shared##className == nil) {\
\
        static dispatch_once_t onceToken;\
        dispatch_once(&onceToken, ^{\
\
            shared##className = [super init];\
            if([shared##className respondsToSelector:@selector(initParameter)]){\
                [shared##className performSelector:@selector(initParameter)];\
            }\
\
        });\
\
    }\
\
    return shared##className;\
\
} \
\

#else

//***************非ARC***************//
    #define CREATE_SINGLETON_WITHCLASSNAME(className) \
\
static className *shared##className = nil;\
+ (instancetype)shared##className {\
\
    return [[self alloc] init];\
\
}\
\
- (instancetype)init\
{\
\
    if (shared##className == nil) {\
\
        static dispatch_once_t onceToken;\
        dispatch_once(&onceToken, ^{\
\
            shared##className = [super init];\
            if([shareAlix respondsToSelector:@selector(initParameter)]){\
                [shareAlix performSelector:@selector(initParameter)];\
            }\
\
        });\
\
    }\
\
    return shared##className;\
\
} \
\
- (void)release\
{\
    \
}\
\
- (instancetype)retain\
{\
    return self;\
}\
\
- (NSUInteger)retainCount\
{\
    return 1;\
}\

#endif

#endif
