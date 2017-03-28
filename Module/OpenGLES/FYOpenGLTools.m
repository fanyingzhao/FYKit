//
//  FYOpenGLTools.m
//  OpenGLES_Light
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYOpenGLTools.h"
#import <GLKit/GLKit.h>

@implementation FYOpenGLTools

+ (void)checkError {
    GLenum error = glGetError();
    if(GL_NO_ERROR != error) {
        NSLog(@"GL Error: 0x%x", error);
    }
}

@end
