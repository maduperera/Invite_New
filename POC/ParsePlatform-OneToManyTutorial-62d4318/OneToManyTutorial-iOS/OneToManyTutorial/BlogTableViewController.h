///Users/maduperera/Desktop/Invite_New/POC/ParsePlatform-OneToManyTutorial-62d4318/OneToManyTutorial-iOS/OneToManyTutorial.xcodeproj

#import <UIKit/UIKit.h>

@interface BlogTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *postArray;

- (void)addPostButtonHandler:(id)sender;
- (void)refreshButtonHandler:(id)sender;

@end
