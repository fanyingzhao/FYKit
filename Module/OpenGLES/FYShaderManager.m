//
//  FYShaderManager.m
//  OpenGLES_Light
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import "FYShaderManager.h"

@implementation FYShaderManager

+ (instancetype)sharedShaderManager {
    static FYShaderManager* shaderManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shaderManagerInstance = [[FYShaderManager alloc] init];
    });
    return shaderManagerInstance;
}

- (instancetype)initWithVertexShaderString:(NSString *)vShaderString fragmentShaderString:(NSString *)fShaderString {
    if (self = [super init]) {
        self.program = glCreateProgram();
        
        if (![self compileShader:&_vertexShader type:GL_VERTEX_SHADER string:vShaderString]) {
            NSLog(@"加载顶点着色器失败");
        }
        if (![self compileShader:&_fragmentShader type:GL_FRAGMENT_SHADER string:fShaderString]) {
            NSLog(@"加载片段着色器失败");
        }
        
        glAttachShader(self.program, _vertexShader);
        glAttachShader(self.program, _fragmentShader);
        
        if (![self link]) {
            NSLog(@"着色器链接失败");
        }
    }
    return self;
}

- (instancetype)initWithVertexShaderFilePath:(NSString *)vShaderFilePath fragmentShaderFilePath:(NSString *)fShaderFilePath {
    NSData* vShaderData = [NSData dataWithContentsOfFile:vShaderFilePath];
    NSData* fShaderData = [NSData dataWithContentsOfFile:fShaderFilePath];
    NSString* vShaderString = [[NSString alloc] initWithData:vShaderData encoding:NSUTF8StringEncoding];
    NSString* fShaderString = [[NSString alloc] initWithData:fShaderData encoding:NSUTF8StringEncoding];
    
    return [self initWithVertexShaderString:vShaderString fragmentShaderString:fShaderString];
}

- (BOOL)compileShader:(GLuint*)shader type:(GLuint)type string:(NSString*)shaderString {
    GLint status = 0;
    const GLchar* source = NULL;
    source = [shaderString UTF8String];
    if (source == NULL) {
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);

    if (status != GL_TRUE) {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            NSLog(@"Shader compile log:\n%s", log);
            free(log);
        }
    }
    
    return status == GL_TRUE;
}

- (GLuint)attributeIndex:(NSString *)attributeName {
    return glGetAttribLocation(self.program, [attributeName UTF8String]);
}

- (GLuint)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(self.program, [uniformName UTF8String]);
}

- (BOOL)link {
    GLint status;
    glLinkProgram(self.program);
    
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE)
        return NO;
    
    if (_vertexShader) {
        glDeleteShader(_vertexShader);
        _vertexShader = 0;
    }
    if (_fragmentShader) {
        glDeleteShader(_fragmentShader);
        _fragmentShader = 0;
    }
    
    return YES;
}

- (void)use {
    glUseProgram(self.program);
}

- (void)dealloc {
    if (_vertexShader) {
        glDeleteShader(_vertexShader);
    }
    if (_fragmentShader) {
        glDeleteShader(_fragmentShader);
    }
    if (self.program) {
        glDeleteShader(self.program);
    }
}

@end
