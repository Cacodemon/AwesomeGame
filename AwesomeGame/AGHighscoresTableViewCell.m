//
//  AGHighscoresTableViewCell.m
//  AwesomeGame
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

#import "AGHighscoresTableViewCell.h"
#import "AGHighscoresManager.h"

@interface AGHighscoresTableViewCell ()

//@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *placeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoresLabel;

@end

@implementation AGHighscoresTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighscoresRecord:(NSDictionary*)record {
    self.placeNumberLabel.text = [record objectForKey:kHighscoresPlace];
    self.dateLabel.text = [record objectForKey:kHighscoresDate];
    self.scoresLabel.text = [record objectForKey:kHighscoresScores];
}
@end
