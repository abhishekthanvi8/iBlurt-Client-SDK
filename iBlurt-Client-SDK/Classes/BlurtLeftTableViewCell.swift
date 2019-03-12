//
//  BlurtLeftTableViewCell.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit

class BlurtLeftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var handlerImage: UIImageView!
    @IBOutlet weak var contentDisplayView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        contentDisplayView?.layer.cornerRadius = 5.0
        contentDisplayView?.layer.borderColor = UIColor.lightGray.cgColor
        contentDisplayView?.layer.borderWidth = 0.2
        contentDisplayView?.layer.shadowColor = UIColor(red: 225.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0).cgColor
        contentDisplayView?.layer.shadowOpacity = 7.0
        contentDisplayView?.layer.shadowRadius = 5.0
        contentDisplayView?.layer.shadowOffset = CGSize(width: 15.0, height: 15.0)
        
        contentDisplayView.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
