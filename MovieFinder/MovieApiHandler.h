//
//  MovieApiHandler.h
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/5/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SortManager.h"

@protocol MovieApiHandlerDelegate;

@interface MovieApiHandler : NSObject

@property (nonatomic,strong) id<MovieApiHandlerDelegate> delegate;

- (instancetype)initWithDelegate:(id<MovieApiHandlerDelegate>)delegate;

- (void)getMovies:(NSString*)searchText apiKey:(NSString*)api;

@end


@protocol MovieApiHandlerDelegate <NSObject>

@optional

- (void)serchedmovieResult:(NSArray *)result;

@end
