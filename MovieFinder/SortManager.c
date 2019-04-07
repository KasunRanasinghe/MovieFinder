//
//  SortManager.c
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/6/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#include "SortManager.h"


void display(struct movie list[], int s)
{
    int i;
    for (i = 0; i < s; i++)
    {
        printf("%d\t%f\n", list[i].movieId, list[i].rate);
    }
}

struct  movie * sortDecending(struct movie list[], int s)
{
    int i, j;
    struct movie temp;
   
    for (i = 0; i < s - 1; i++)
    {
        for (j = 0; j < (s - 1-i); j++)
        {
            if (list[j].rate < list[j + 1].rate)
            {
                temp = list[j];
                list[j] = list[j + 1];
                list[j + 1] = temp;
            }
        }
    }
    
    display(list, s);
    return &list[0];
}



