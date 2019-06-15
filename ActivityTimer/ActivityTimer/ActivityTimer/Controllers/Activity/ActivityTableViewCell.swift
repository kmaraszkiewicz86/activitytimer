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

}
