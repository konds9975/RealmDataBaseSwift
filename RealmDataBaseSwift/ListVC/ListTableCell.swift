//
//  ListTableCell.swift
//  RealmDataBaseSwift
//
//  Created by Inkswipe on 5/18/18.
//  Copyright © 2018 Inkswipe. All rights reserved.
//

import UIKit

class ListTableCell: UITableViewCell {

    @IBOutlet var userImage : UIImageView!
    @IBOutlet var userNameLbl : UILabel!
    @IBOutlet var userAddressLbl : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
