//
//  LocalizedTool.m
//  LocalizedTool-iOS
//
//  Created by xaoxuu on 27/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "LocalizedTool.h"
#import <AXKit/AXKit.h>

static NSString *keyStr = @"\" = \"";
static NSString *fileName = @"Localizable.txt";


static NSMutableArray<NSString *> *inputArray;
static NSMutableArray<NSString *> *inputKeys;

static NSMutableArray<NSString *> *outputArray;
static NSMutableArray<NSString *> *outputKeys;

static inline void delete(NSMutableArray<NSString *> *inputArray, int *index){
    [inputArray removeObjectAtIndex:*index];
    *index = *index - 1;
}

static inline void filter(NSMutableArray<NSString *> *inputArray){
    for (int i = 0; i < inputArray.count; i++) {
        NSString *tmpStr = inputArray[i];
        // 删掉空行
        if (tmpStr.length < 6) { // ""="";
            //            AXLogFailure(@"%@", tmpStr);
            delete(inputArray, &i);
            continue;
        }
        
        NSString *tmp2 = [tmpStr substringToIndex:2];
        if ([tmp2 isEqualToString:@"//"] || [tmp2 isEqualToString:@"/*"]) {
            delete(inputArray, &i);
            continue;
        }
        
        //
        if (![tmpStr containsString:keyStr]) {
            delete(inputArray, &i);
            continue;
        }
        
    }
}

static inline NSMutableArray<NSString *> *getKeys(NSMutableArray<NSString *> *inputArray){
    NSMutableArray<NSString *> *output = [NSMutableArray array];
    [inputArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeOfString:keyStr];
        NSString *tmp = [obj substringToIndex:range.location];
        tmp = [tmp substringFromIndex:1];
        
        [output addObject:tmp];
        
    }];
    return output;
}

@implementation LocalizedTool

+ (NSString *)mergeLocalizedStringFile{
    outputKeys = [NSMutableArray array];
    // 清除
    fileName.docPath.removeFile();
    // 从路径读取文件
    NSError *error;
    NSString *inputString = [NSString stringWithContentsOfFile:fileName.mainBundlePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        AXLogError(error);
    }
    // 按行分组
    NSMutableArray *inputArray = [NSMutableArray arrayWithArray:[inputString componentsSeparatedByString:@"\n"]];
    // 过滤无效行
    filter(inputArray);
    // 提取key
    inputKeys = getKeys(inputArray);
    [inputKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![outputKeys containsObject:key]) {
            NSString *tmp = inputArray[idx];
            NSString *appendString = [NSString stringWithFormat:@"/* No comment provided by engineer. */\n%@\n\n", tmp];
            // 添加到keys
            [outputKeys addObject:key];
            // 添加到文件
            fileName.docPath.saveStringByAppendingToEndOfFile(appendString);
        }
    }];
    return fileName.docPath;
}

@end
