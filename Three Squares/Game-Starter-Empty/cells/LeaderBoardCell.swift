//
//  LeaderBoardCell.swift
//  ThreeSquares
//
//  Created by Jonathan Kopp on 10/1/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class LeaderBoardCell: UITableViewCell {
    //@IBOutlet weak var userImage: UIImageView!
    //@IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    
    override func layoutSubviews() {
        let huh = frame.width / 2
        self.scoreLabel.frame = CGRect(x: 5, y: 10, width: 100, height: 20)
        self.nameLabel.frame = CGRect(x: huh, y: 10, width: 200, height: 20)
        nameLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 21)
        scoreLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 21)
        self.nameLabel.sizeToFit()
        self.scoreLabel.sizeToFit()
    }
    //yes this is the one...
    
}
