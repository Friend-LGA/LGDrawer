//
//  CollectionViewController.m
//  LGDrawerDemo
//
//  Created by Grigory Lutkov on 18.05.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "CollectionViewController.h"
#import "LGDrawer.h"

#define kSide 60.f
#define kSize CGSizeMake(60.f, 60.f)

#define kImageSide 90.f
#define kImageSize CGSizeMake(90.f, 90.f)

#define kBackgroundColor [UIColor colorWithWhite:0.9 alpha:1.f]

#define kOffset CGPointMake(-1.f, -1.f)

#define kRotate 0.f

#define kCornerRadius 12.f

#define kFillColor [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f]

#define kStrokeColor        [UIColor whiteColor]
#define kStrokeThickness    2.f
#define kStrokeDash         @[@4.f, @2.f]
#define kStrokeType         LGDrawerStrokeTypeCenter

#define kShadowColor    [UIColor colorWithWhite:0.f alpha:0.6]
#define kShadowOffset   CGPointMake(2.f, 2.f)
#define kShadowBlur     6.f
#define kShadowType     LGDrawerShadowTypeFill

#define kThinckness     12.f

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
}

@end

#pragma mark -

@interface CollectionViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CollectionViewController

- (instancetype)init
{
    CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSUInteger numberOfCellsInARow = screenWidth/100.f;
    
    CGFloat cellSide = (screenWidth-2.f-2.f-2.f*(numberOfCellsInARow-1))/numberOfCellsInARow;
    
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f);
    collectionViewLayout.itemSize = CGSizeMake(cellSide, cellSide);
    collectionViewLayout.minimumLineSpacing = 2.f;
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.headerReferenceSize = CGSizeZero;
    collectionViewLayout.footerReferenceSize = CGSizeZero;
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    if (self)
    {
        self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.f];
        
        self.title = @"LGDrawer";
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self prepareData];
    }
    return self;
}

- (void)prepareData
{
    _dataArray = [NSMutableArray new];
    
    [_dataArray addObject:[LGDrawer drawRectangleWithImageSize:kImageSize
                                                          size:kSize
                                                        offset:kOffset
                                                        rotate:kRotate
                                                roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                                  cornerRadius:kCornerRadius
                                               backgroundColor:kBackgroundColor
                                                     fillColor:kFillColor
                                                   strokeColor:kStrokeColor
                                               strokeThickness:kStrokeThickness
                                                    strokeDash:kStrokeDash
                                                    strokeType:kStrokeType
                                                   shadowColor:kShadowColor
                                                  shadowOffset:kShadowOffset
                                                    shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawEllipseWithImageSize:kImageSize
                                                        size:kSize
                                                      offset:kOffset
                                                      rotate:kRotate
                                             backgroundColor:kBackgroundColor
                                                   fillColor:kFillColor
                                                 strokeColor:kStrokeColor
                                             strokeThickness:kStrokeThickness
                                                  strokeDash:kStrokeDash
                                                  strokeType:kStrokeType
                                                 shadowColor:kShadowColor
                                                shadowOffset:kShadowOffset
                                                  shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawTriangleWithImageSize:kImageSize
                                                         size:CGSizeMake(kSide+kCornerRadius/2, kSide+kCornerRadius/2)
                                                       offset:kOffset
                                                       rotate:kRotate
                                                 cornerRadius:kCornerRadius/2
                                                    direction:LGDrawerDirectionTop
                                              backgroundColor:kBackgroundColor
                                                    fillColor:kFillColor
                                                  strokeColor:kStrokeColor
                                              strokeThickness:kStrokeThickness
                                                   strokeDash:kStrokeDash
                                                  shadowColor:kShadowColor
                                                 shadowOffset:kShadowOffset
                                                   shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawPlusWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness
                                           roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                             cornerRadius:kCornerRadius
                                          backgroundColor:kBackgroundColor
                                                fillColor:kFillColor
                                              strokeColor:kStrokeColor
                                          strokeThickness:kStrokeThickness
                                               strokeDash:kStrokeDash
                                               strokeType:kStrokeType
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawCrossWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness
                                           roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                             cornerRadius:kCornerRadius
                                          backgroundColor:kBackgroundColor
                                                fillColor:kFillColor
                                              strokeColor:kStrokeColor
                                          strokeThickness:kStrokeThickness
                                               strokeDash:kStrokeDash
                                               strokeType:kStrokeType
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawTickWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness*0.66
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:nil
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawArrowWithImageSize:kImageSize
                                                      size:CGSizeMake(kSide*0.66, kSide)
                                                    offset:kOffset
                                                    rotate:kRotate
                                                 thickness:kThinckness*0.66
                                                 direction:LGDrawerDirectionLeft
                                           backgroundColor:kBackgroundColor
                                                     color:kFillColor
                                                      dash:nil
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawArrowTailedWithImageSize:kImageSize
                                                            size:kSize
                                                          offset:kOffset
                                                          rotate:kRotate
                                                       thickness:kThinckness*0.66
                                                       direction:LGDrawerDirectionBottomRight
                                                 backgroundColor:kBackgroundColor
                                                           color:kFillColor
                                                            dash:nil
                                                     shadowColor:kShadowColor
                                                    shadowOffset:kShadowOffset
                                                      shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawLineWithImageSize:kImageSize
                                                   length:kSide
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness
                                                direction:LGDrawerLineDirectionVertical
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawPlusWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness*0.66
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawCrossWithImageSize:kImageSize
                                                      size:kSize
                                                    offset:kOffset
                                                    rotate:kRotate
                                                 thickness:kThinckness*0.66
                                           backgroundColor:kBackgroundColor
                                                     color:kFillColor
                                                      dash:kStrokeDash
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawHeartWithImageSize:kImageSize
                                                      size:kSize
                                                    offset:kOffset
                                                    rotate:kRotate
                                           backgroundColor:kBackgroundColor
                                                 fillColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                               strokeColor:kStrokeColor
                                           strokeThickness:kStrokeThickness
                                                strokeDash:kStrokeDash
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [_dataArray addObject:[LGDrawer drawStarWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                          backgroundColor:kBackgroundColor
                                                fillColor:[UIColor yellowColor]
                                              strokeColor:kFillColor
                                          strokeThickness:kStrokeThickness
                                               strokeDash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    CGSize size = CGSizeMake(kSide*0.8, kSide*0.6);
    CGFloat thickness = size.height/4;
    
    [_dataArray addObject:[LGDrawer drawMenuWithImageSize:kImageSize
                                                     size:size
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:thickness
                                                   dotted:YES
                                             dotsPosition:LGDrawerMenuDotsPositionLeft
                                         dotsCornerRadius:thickness/2
                                        linesCornerRadius:thickness/2
                                          backgroundColor:kBackgroundColor
                                                fillColor:kFillColor
                                              strokeColor:nil
                                          strokeThickness:0.f
                                               strokeDash:nil
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    // -----
    
    size = CGSizeMake(kImageSide*0.9, kImageSide*0.9);
    
    UIImage *image1 = [LGDrawer drawEllipseWithImageSize:kImageSize
                                                    size:size
                                                  offset:CGPointZero
                                                  rotate:0.f
                                         backgroundColor:kBackgroundColor
                                               fillColor:kFillColor
                                             strokeColor:nil
                                         strokeThickness:0.f
                                              strokeDash:nil
                                              strokeType:0
                                             shadowColor:nil
                                            shadowOffset:CGPointZero
                                              shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.55, kImageSide*0.55);
    
    UIImage *image2 = [LGDrawer drawRectangleWithImageSize:size
                                                      size:size
                                                    offset:CGPointZero
                                                    rotate:0.f
                                            roundedCorners:UIRectCornerAllCorners
                                              cornerRadius:5.f
                                           backgroundColor:nil
                                                 fillColor:kBackgroundColor
                                               strokeColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                           strokeThickness:2.f
                                                strokeDash:nil
                                                strokeType:0
                                               shadowColor:nil
                                              shadowOffset:CGPointZero
                                                shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.35, kImageSide*0.35);
    
    UIImage *image3 = [LGDrawer drawHeartWithImageSize:size
                                                  size:size
                                                offset:CGPointZero
                                                rotate:0.f
                                       backgroundColor:nil
                                             fillColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                           strokeColor:nil
                                       strokeThickness:0.f
                                            strokeDash:nil
                                           shadowColor:nil
                                          shadowOffset:CGPointZero
                                            shadowBlur:0.f];
    
    [_dataArray addObject:[LGDrawer drawImageOnImage:@[image1,
                                                       image2,
                                                       image3]]];
    
    // -----
    
    size = CGSizeMake(kImageSide*0.9, kImageSide*0.9);
    
    image1 = [LGDrawer drawTriangleWithImageSize:kImageSize
                                            size:size
                                          offset:CGPointZero
                                          rotate:0.f
                                    cornerRadius:0.f
                                       direction:LGDrawerDirectionTop
                                 backgroundColor:kBackgroundColor
                                       fillColor:kFillColor
                                     strokeColor:nil
                                 strokeThickness:0.f
                                      strokeDash:nil
                                     shadowColor:nil
                                    shadowOffset:CGPointZero
                                      shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.45, kImageSide*0.45);
    
    image2 = [LGDrawer drawStarWithImageSize:size
                                        size:size
                                      offset:CGPointZero
                                      rotate:0.f
                             backgroundColor:nil
                                   fillColor:[UIColor yellowColor]
                                 strokeColor:nil
                             strokeThickness:0.f
                                  strokeDash:nil
                                 shadowColor:nil
                                shadowOffset:CGPointZero
                                  shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.35, kImageSide*0.35);
    
    image3 = [LGDrawer drawStarWithImageSize:size
                                        size:size
                                      offset:CGPointZero
                                      rotate:0.f
                             backgroundColor:nil
                                   fillColor:kFillColor
                                 strokeColor:nil
                             strokeThickness:0.f
                                  strokeDash:nil
                                 shadowColor:nil
                                shadowOffset:CGPointZero
                                  shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.3, kImageSide*0.3);
    
    UIImage *image4 = [LGDrawer drawStarWithImageSize:size
                                                 size:size
                                               offset:CGPointZero
                                               rotate:0.f
                                      backgroundColor:nil
                                            fillColor:[UIColor blackColor]
                                          strokeColor:nil
                                      strokeThickness:0.f
                                           strokeDash:nil
                                          shadowColor:nil
                                         shadowOffset:CGPointZero
                                           shadowBlur:0.f];
    
    UIImage *image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                                  image1:image1
                                            image1Offset:CGPointZero
                                                  image2:image2
                                            image2Offset:CGPointMake(0.f, 12.f)
                                                   clear:NO];
    
    image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                         image1:image5
                                   image1Offset:CGPointZero
                                         image2:image3
                                   image2Offset:CGPointMake(0.f, 12.5)
                                          clear:NO];
    
    image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                         image1:image5
                                   image1Offset:CGPointZero
                                         image2:image4
                                   image2Offset:CGPointMake(0.f, 12.5)
                                          clear:YES];
    
    [_dataArray addObject:image5];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - UICollectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = _dataArray[indexPath.item];
    
    return cell;
}

@end
