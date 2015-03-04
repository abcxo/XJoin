//
//  VTableViewModel.h
//  VViewModel
//
//  Created by shadow on 14-5-9.
//  Copyright (c) 2014年 genio. All rights reserved.
//

#import "VViewModel.h"

#define VTABLEVIEWMODEL_SECTIONS @"VTABLEVIEWMODEL_SECTIONS"

#define VTABLEVIEWMODEL_SECTION_CONTENT @"VTABLEVIEWMODEL_SECTION_CONTENT"

#define VTABLEVIEWMODEL_SECTION_HEIGHT @"VTABLEVIEWMODEL_SECTION_HEIGHT"

#define VTABLEVIEWMODEL_CELLS   @"VTABLEVIEWMODEL_CELLS"

#define VTABLEVIEWMODEL_CELL_CONTENT    @"VTABLEVIEWMODEL_CELL_CONTENT"

#define VTABLEVIEWMODEL_CELL_HEIGHT    @"VTABLEVIEWMODEL_CELL_HEIGHT"



@protocol VTableViewModelDelegate <NSObject>
//- (id)sectionForIndex:(NSInteger)index;
//- (NSInteger)sectionCount;
//- (CGFloat)sectionHeightForIndex:(NSInteger)index;
//- (id)cellForIndex:(NSIndexPath *)index;
//- (id)cellForIndex:(NSIndexPath *)index key:(id)key;
//- (NSInteger)cellCountForIndex:(NSInteger)index;
//- (CGFloat)cellHeightForIndex:(NSIndexPath *)index;

@end


@interface VTableViewModel : VViewModel <VTableViewModelDelegate>
@end
@interface  VTableViewModelUI : VViewModelUI
@end
