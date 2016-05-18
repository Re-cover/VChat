//
//  NSString+FirstCharacter.m
//  VChat
//
//  Created by Recover on 16/5/18.
//  Copyright © 2016年 Recover. All rights reserved.
//

#import "NSString+FirstCharacter.h"

@implementation NSString (FirstCharacter)

- (NSString *)firstCharacter {
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

@end
