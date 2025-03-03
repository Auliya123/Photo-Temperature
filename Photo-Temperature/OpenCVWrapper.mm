//
//  OpenCVWrapper.m
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 02/03/25.
//

#import "OpenCVWrapper.h"
#import <opencv/opencv.hpp>
#import <opencv/imgcodecs/ios.h>

@interface UIImage (OpenCVWrapper)
- (void)convertToMat: (cv::Mat *)pMat: (bool)alphaExists;
@end

@implementation UIImage (OpenCVWrapper)
- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self; // No need to fix

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return normalizedImage;
}

- (void)convertToMat: (cv::Mat *)pMat: (bool)alphaExists {
    UIImage *fixedImage = [self fixOrientation];  // Ensure the image is upright
    UIImageToMat(fixedImage, *pMat, alphaExists);
}
@end



@implementation OpenCVWrapper

+ (NSString *)getOpenCVVersion {
    return [NSString stringWithFormat:@"%d.%d.%d", CV_VERSION_MAJOR, CV_VERSION_MINOR, CV_VERSION_REVISION];
}

/**
 * Adjusts image temperature
 * @param image The input image
 * @param value Temperature adjustment (-100 to 100, negative for cooler, positive for warmer)
 * @return Temperature-adjusted UIImage
 */

+ (UIImage *)adjustTemperature:(UIImage *)image withValue:(float)value {
    cv::Mat mat;
    [image convertToMat:&mat :false];

    if (mat.empty()) {
        NSLog(@"Error: Image not found!");
        return nil;
    }

    float blueGamma = 0.0025 * value + 1;  // More blue for cold
    float redGamma = -0.0025 * value + 1;   // More red for warm
    double satGamma  =  -0.002 * value + 1;    // Reduce or boost saturation

    // Function to apply gamma correction
    auto gammaFunction = [](cv::Mat &channel, double gamma) {
        cv::Mat lookupTable(1, 256, CV_8U);
        uchar *p = lookupTable.ptr();
        for (int i = 0; i < 256; i++) {
            p[i] = cv::saturate_cast<uchar>(pow(i / 255.0, 1.0 / gamma) * 255.0);
        }
        cv::LUT(channel, lookupTable, channel);
    };

    // Apply gamma correction to blue and red channels
    std::vector<cv::Mat> channels;
    cv::split(mat, channels);
    gammaFunction(channels[0], blueGamma);  // Blue channel
    gammaFunction(channels[2], redGamma);   // Red channel
    cv::merge(channels, mat);

    // Convert to HSV and adjust saturation
    cv::Mat hsv;
    cv::cvtColor(mat, hsv, cv::COLOR_BGR2HSV);
    std::vector<cv::Mat> hsvChannels;
    cv::split(hsv, hsvChannels);
    gammaFunction(hsvChannels[1], satGamma); // Adjust saturation
    cv::merge(hsvChannels, hsv);
    cv::cvtColor(hsv, mat, cv::COLOR_HSV2BGR);

    UIImage *resultImage = MatToUIImage(mat);
    return resultImage;
}

@end
