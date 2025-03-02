//
//  OpenCVWrapper.m
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 02/03/25.
//

#import "OpenCVWrapper.h"
#import <opencv/opencv.hpp>

@implementation OpenCVWrapper

+ (NSString *)getOpenCVVersion {
    return [NSString stringWithFormat:@"%d.%d.%d", CV_VERSION_MAJOR, CV_VERSION_MINOR, CV_VERSION_REVISION];
}

@end
