//
//  SharedInstanceGCD.h
//  zaime
//
//  Created by 1528 MAC on 14-8-8.
//  Copyright (c) 2014年 kld. All rights reserved.
//

#ifndef SHARED_INSTANCE_GCD
#define SHARED_INSTANCE_GCD \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_USING_BLOCK
#define SHARED_INSTANCE_GCD_USING_BLOCK(block) \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME
#define SHARED_INSTANCE_GCD_WITH_NAME(classname)                        \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK
#define SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK(classname, block) \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK
#define DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
#endif
