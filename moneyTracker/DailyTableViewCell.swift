//
//  DailyTableViewCell.swift
//  moneyTracker
//
//  Created by User on 25/05/2015.
//  Copyright (c) 2015 User. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var bgWidth = UIScreen.mainScreen().bounds.width
    
    var leftImageView: UIImageView?
    var leftTextLabel: UILabel?
    var detailLabel: UILabel?
    var rightTextLabel: UILabel?
    var accBtnImg: UIImageView?
    var accessoryBtn: UIButton?
    var bottomEdge: UILabel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftImageView = UIImageView(frame: CGRect(x: 8, y: frame.height - 38, width: 76, height: 76))
        leftTextLabel = UILabel(frame: CGRect(x: 90, y: frame.height/2, width: 100, height: frame.height/2 + 8))
        leftTextLabel?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
        leftTextLabel?.font      = UIFont.boldSystemFontOfSize(22)
        
        detailLabel   = UILabel(frame: CGRect(x: 90, y: frame.height + 8, width: 100, height: frame.height/2))
        detailLabel?.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        detailLabel?.font      = UIFont.italicSystemFontOfSize(15)
        
        rightTextLabel = UILabel(frame: CGRect(x: frame.width - 100, y: frame.height/2, width: 110, height: frame.height))
        rightTextLabel?.textColor = UIColor(red: 0.82, green: 0.47, blue: 0.43, alpha: 1)
        rightTextLabel?.textAlignment = NSTextAlignment.Right
        rightTextLabel?.font = UIFont.boldSystemFontOfSize(33)
        
        var accBtnRect = CGRect(x: frame.width + 10, y: frame.height - 10, width: 30, height: 30)
        accBtnImg = UIImageView(frame: accBtnRect)
        accBtnImg?.image = UIImage(named: "dragdown")
        accessoryBtn = UIButton(frame: accBtnRect)
        
        bottomEdge = UILabel(frame: CGRect(x: 0, y: 0, width: bgWidth, height: 1))
        bottomEdge?.backgroundColor = UIColor(red: 0.51, green: 0.48, blue: 0.46, alpha: 0.5)
        
        self.addSubview(leftImageView!)
        self.addSubview(leftTextLabel!)
        self.addSubview(detailLabel!)
        self.addSubview(rightTextLabel!)
        self.addSubview(bottomEdge!)
        self.addSubview(accBtnImg!)
        self.addSubview(accessoryBtn!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
