//
//  FYOpenGLTools.h
//  OpenGLES_Light
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

@interface FYOpenGLTools : NSObject

+ (void)checkError;

@end
