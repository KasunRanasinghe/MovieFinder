//
//  SortManager.h
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/6/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#ifndef SortManager_h
#define SortManager_h

#include <stdio.h>


struct movie
{
    int movieId;
    float rate;
};

void display(struct movie list[], int s);
struct  movie * sortDecending(struct movie list[], int s);

#endif /* SortManager_h */
