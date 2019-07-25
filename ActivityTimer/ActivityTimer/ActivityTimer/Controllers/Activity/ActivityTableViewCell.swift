//
//  ActivityTableViewCell.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 24/05/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit

///The ActivityTableViewCell class
class ActivityTableViewCell: UITableViewCell {

    ///The name label outlet
    @IBOutlet weak var nameLabel: UILabel!
    
    ///The awake from nib event
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    ///The set selected event
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        let actionButton = UIButton(type: .custom)
        actionButton.setTitle("Test", for: .normal)
        
        self.addSubview(actionButton)
        
        self.addConstraint(NSLayoutConstraint(item: actionButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.0, constant: 10.0))
        
        self.addConstraint(NSLayoutConstraint(item: actionButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 0.6, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: actionButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 0, constant: 10.0))
        
        self.addConstraint(NSLayoutConstraint(item: actionButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0, constant: 10.0))
    }

}
