//
//  MyTableViewController.m
//  XMLApp
//
//  Created by Vikash Soni on 20/09/13.
//  Copyright (c) 2013 Vikash Soni. All rights reserved.
//

#import "MyTableViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *book;
    NSMutableString *name;
    NSMutableString *address;
    NSMutableString *country;
    NSString *element;
    NSString *filePath;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.edumobile.org/blog/uploads/XML-parsing-data/Data.xml"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",data);
    
    if (data)
    {
        filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"myData.xml"];
        NSLog(@"filePath %@", filePath);
        [data writeToFile:filePath atomically:YES];
    }
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:filePath])
    {
        NSLog(@"Writable");
    }
    else
    {
        NSLog(@"Not Writable");
    }
    
    [self parseDataFromFile];
}

- (void)parseDataFromFile
{
    NSLog(@"File exists at path: %@ %hhd", filePath, [[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    NSData *xmlData = [NSData dataWithContentsOfFile:filePath];
    parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    [parser parse];
    NSLog(@"%@",xmlData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feeds.count;
    NSLog(@"tell me %d",feeds.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text       = [[feeds objectAtIndex:indexPath.row] objectForKey: @"name"];
    cell.detailTextLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"address"];
    return cell;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    element = elementName;
    
    if ([element isEqualToString:@"Book"])
    {
        book    = [[NSMutableDictionary alloc] init];
        name    = [[NSMutableString alloc] init];
        address = [[NSMutableString alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Book"])
    {
        [book setObject:name forKey:@"name"];
        [book setObject:address forKey:@"address"];
        [feeds addObject:[book copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([element isEqualToString:@"name"])
    {
        [name appendString:string];
    }
    else if ([element isEqualToString:@"address"])
    {
        [address appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"found file and started parsing");
}

- (void)parseXMLFileAtURL:(NSString *)URL //URL is the file path (i.e. /Applications/MyExample.app/MyFile.xml)
{
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL fileURLWithPath:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    parser = [[ NSClassFromString(@"NSXMLParser") alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
	[parser parse];
}

@end
