# LGDrawer

iOS helper draws UIImages programmatically.
It contains collection of different images like rectangle, triangle, ellipse, plus, minus, cross, line, tick, arrow, heart, star and others.
You can customize a lot of parameters like size of image area, size of image, background color, fill color, stroke type and color, rotation, shadows and others.
Also you can combine different images into one image.

## Preview

<img src="https://raw.githubusercontent.com/Friend-LGA/ReadmeFiles/master/LGDrawer/1.png"/>

## Installation

### With source code

[Download repository](https://github.com/Friend-LGA/LGDrawer/archive/master.zip), then add [LGDrawer directory](https://github.com/Friend-LGA/LGDrawer/blob/master/LGDrawer/) to your project.

### With CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the "Get Started" section for more details.

#### Podfile

```
platform :ios, '6.0'
pod 'LGDrawer', '~> 1.0.0'
```

## Usage

In the source files where you need to use the library, import the header file:

```objective-c
#import "LGDrawer.h"
```

### Draw

For example how to draw rectangle:

```objective-c
UIImage *rectangle = [LGDrawer drawRectangleWithImageSize:CGSizeMake(90.f, 90.f)
                                                     size:CGSizeMake(60.f, 60.f)
                                                   offset:CGPointZero
                                                   rotate:0.f
                                           roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                             cornerRadius:10.f
                                          backgroundColor:[UIColor whiteColor]
                                                fillColor:[UIColor blueColor]
                                              strokeColor:[UIColor blackColor]
                                          strokeThickness:2.f
                                               strokeDash:@[@4.f, @2.f] // first - length of line, second - length of space | you can use more arguments in array
                                               strokeType:LGDrawerStrokeTypeCenter
                                              shadowColor:[UIColor colorWithWhite:0.f alpha:0.5]
                                             shadowOffset:CGPointMake(2.f, 2.f)
                                               shadowBlur:6.f]
```

### More

For more details try Xcode [Demo project](https://github.com/Friend-LGA/LGDrawer/blob/master/Demo) and see [LGDrawer.h](https://github.com/Friend-LGA/LGDrawer/blob/master/LGDrawer/LGDrawer.h)

## License

LGDrawer is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/Friend-LGA/LGDrawer/master/LICENSE) for details.
