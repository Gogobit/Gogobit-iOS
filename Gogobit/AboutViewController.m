//
//  AboutViewController.m
//  Gogobit
//
//  Created by Wilson H. on 3/8/16.
//  Copyright © 2016 Wilson H. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

NSString const *DONATED_ADDRESS = @"1AF27uJui6ucj4hht1AToCmn16Ls5Y1KeX";

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"About";
    self.qrCodeImageView.image = [self createQRForString:[NSString stringWithFormat:@"bitcoin:%@", DONATED_ADDRESS]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];

    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:[qrFilter outputImage] fromRect:[[qrFilter outputImage] extent]];

    int scale = 30;
    UIGraphicsBeginImageContext(CGSizeMake([[qrFilter outputImage] extent].size.width * scale, [qrFilter outputImage].extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *preImage = UIGraphicsGetImageFromCurrentImageContext();

    //Cleaning up .
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);

    // Rotate the image
    UIImage *qrImage = [UIImage imageWithCGImage:[preImage CGImage] scale:[preImage scale] orientation:UIImageOrientationDownMirrored];
    return qrImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
