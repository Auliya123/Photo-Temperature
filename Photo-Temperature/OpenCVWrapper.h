//
//  OpenCVWrapper.h
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 02/03/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+ (NSString *)getOpenCVVersion;
+ (UIImage *)adjustTemperature: (UIImage *)image withValue:(float)value;
@end


NS_ASSUME_NONNULL_END
