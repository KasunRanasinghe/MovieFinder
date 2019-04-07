//
//  ViewController.m
//  MovieFinder
//
//  Created by Kasun Ranasinghe on 4/5/19.
//  Copyright © 2019 Kasun Ranasinghe. All rights reserved.
//

#import "ViewController.h"
#import "MovieApiHandler.h"
#import "AppDelegate.h"

@interface ViewController ()<MovieApiHandlerDelegate>

@property (nonatomic,strong) NSMutableArray *movieList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic,strong) MovieApiHandler *moviehandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.movieList = [[NSMutableArray alloc] init];
    self.moviehandler = [[MovieApiHandler alloc] initWithDelegate:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Text field methods

- (IBAction)searchTextFieldEndEdit:(id)sender {
    [self.searchTextField endEditing:YES];
}


- (IBAction)findButtonTapped:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]) {
        
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:@"API KEY"
                                   message:@"Enter Api key to Proseed"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       //Do Some action here
                                                       UITextField *textField = alert.textFields[0];
                                                       NSLog(@"text was %@", textField.text);
                                                       [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"apiKey"];
                                                       NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
                                                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] addLoadingView];
                                                       [self.moviehandler getMovies:self.searchTextField.text apiKey:apiKey];
                                                       [self.searchTextField endEditing:YES];
                                                   }];
        
        
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           NSLog(@"cancel btn");
                                                           
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                           
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"placeHolderText";
            textField.keyboardType = UIKeyboardTypeDefault;
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }else{
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"]);
        NSString *apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] addLoadingView];
        [self.moviehandler getMovies:self.searchTextField.text apiKey:apiKey];
        [self.searchTextField endEditing:YES];
    }
    
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = [self.movieList objectAtIndex:indexPath.row];
    
    UILabel *name = (UILabel *)[cell viewWithTag:10];
    name.text = [movie objectForKey:@"title"];
    
    UILabel *description = (UILabel *)[cell viewWithTag:11];
    description.text = [movie objectForKey:@"overview"];
    
    UILabel *rate = (UILabel *)[cell viewWithTag:12];
    rate.text = [[movie objectForKey:@"popularity"] stringValue];
    
    UIImageView *poster = (UIImageView*)[cell viewWithTag:9];

    NSString *imageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w1280%@",[movie objectForKey:@"poster_path"]] ;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0ul);
    dispatch_async(queue, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        UIImage *filmImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
                    [poster setImage:filmImage];
            });
        });
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//call API sample code

-(void)serchedmovieResult:(NSArray *)result{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] removeLoadingView];
    [self.movieList removeAllObjects];
    [self.movieList addObjectsFromArray:result];
    [self.tableView reloadData];
}

@end
