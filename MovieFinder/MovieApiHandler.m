//
//  MovieApiHandler.m
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/5/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#import "MovieApiHandler.h"

@implementation MovieApiHandler

- (instancetype)initWithDelegate:(id<MovieApiHandlerDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}


- (void)getMovies:(NSString*)searchText apiKey:(NSString*)api{
     
    
   // NSString *url = @"https://api.themoviedb.org/3/search/movie?api_key=ca028b15c572a9c4fdcf6ea241e7a4de&language=en-US&query=venom&page=1&include_adult=false";
    
    NSString *url = [NSString stringWithFormat:@"%@/search/movie?api_key=%@&language=en-US&query=%@&page=1&include_adult=false",BASE_URL,api,searchText];
    
    NSLog(@"%@",url);
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // NSString * params =[NSString stringWithFormat:@"type=get_last_progress&sid=%@",subProjectId] ; //get_last_progress&sid
    
    [urlRequest setHTTPMethod:@"GET"];
    // [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //NSLog(@"Response:%@ %@\n", response, error);
     
                                                           
     if(error == nil){
    //NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
      NSLog(@"Data = %@",response);
        NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[response objectForKey:@"results"]];
         NSMutableArray *sorted = [[NSMutableArray alloc] init];
         do {
            NSDictionary *mv = [self sortTheMoviesOnRating:results];
            [sorted addObject:mv];
            [results removeObject:mv];
             
         } while (results.count>0);
        [self.delegate serchedmovieResult:sorted];
         
      }else{
                                                               
                                                               
        }
     }];
    
    [dataTask resume];
}


-(NSDictionary*)sortTheMoviesOnRating:(NSArray*)movieList{
    
    struct movie mvlist[movieList.count];
    
    for (NSDictionary *movie in movieList) {
        int mvIndex = (int)[movieList indexOfObject:movie];
        int mvId =  [[movie objectForKey:@"id"] intValue];
        float mvRate = [[movie objectForKey:@"popularity"] floatValue];
        mvlist[mvIndex].movieId = mvId;
        mvlist[mvIndex].rate = mvRate;
    }
    
    struct movie  mv = *sortDecending(mvlist, (int)movieList.count);
    NSString* filter = @"id == %i";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter,mv.movieId];
    NSArray* filteredData = [movieList filteredArrayUsingPredicate:predicate];
    return  filteredData[0];
    
    
}


@end
