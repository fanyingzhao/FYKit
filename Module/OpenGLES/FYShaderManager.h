//
//  FYShaderManager.h
//  OpenGLES_Light
//
//  Created by fan on 16/8/10.
//  Copyright © 2016年 fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface FYShaderManager : NSObject {
    GLuint _vertexShader;
    GLuint _fragmentShader;
}
@property (nonatomic) GLuint program;

- (instancetype)initWithVertexShaderString:(NSString*)vShaderString
                      fragmentShaderString:(NSString*)fShaderString;
- (instancetype)initWithVertexShaderFilePath:(NSString*)vShaderFilePath
                      fragmentShaderFilePath:(NSString*)fShaderFilePath;

- (GLuint)attributeIndex:(NSString *)attributeName;
- (GLuint)uniformIndex:(NSString *)uniformName;

- (void)use;

@end
