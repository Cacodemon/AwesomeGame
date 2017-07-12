//
//  AGHighscoresTableViewCell.m
//  AwesomeGame
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGHighscoresTableViewCell.h"
#import "AGHighscoresManager.h"
#import "UIColor+AwesomeGame.h"

@interface AGHighscoresTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoresLabel;

@end

@implementation AGHighscoresTableViewCell

- (void)setHighscoresRecord:(NSDictionary*)record {
    
    self.placeNumberLabel.text = [record objectForKey:kHighscoresPlace];
    self.dateLabel.text = [record objectForKey:kHighscoresDate];
    self.scoresLabel.text = [record objectForKey:kHighscoresScores];
    
    switch ([[record objectForKey:kHighscoresPlace] intValue]) {
        case 1:
            self.contentView.backgroundColor = [UIColor agGoldenColor];
            break;
        case 2:
            self.contentView.backgroundColor = [UIColor agSilverColor];
            break;
        case 3:
            self.contentView.backgroundColor = [UIColor agBronzeColor];
            break;
        default:
            self.contentView.backgroundColor = [UIColor agHighscoresTableCellBackgroundColor];
            break;
    }
}
@end
