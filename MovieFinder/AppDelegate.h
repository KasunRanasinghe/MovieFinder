//
//  AppDelegate.h
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/5/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

-(void)addLoadingView;
-(void)removeLoadingView;

@end

