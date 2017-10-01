//
//  NLottoTableViewCell.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 28..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class NLottoTableViewCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet weak var titleDrwNoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultAmountLabel: UILabel!
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var number3Label: UILabel!
    @IBOutlet weak var number4Label: UILabel!
    @IBOutlet weak var number5Label: UILabel!
    @IBOutlet weak var number6Label: UILabel!
    @IBOutlet weak var bonusNumberLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.number1Label.layer.cornerRadius = self.number1Label.frame.width / 2.0
        self.number2Label.layer.cornerRadius = self.number2Label.frame.width / 2.0
        self.number3Label.layer.cornerRadius = self.number3Label.frame.width / 2.0
        self.number4Label.layer.cornerRadius = self.number4Label.frame.width / 2.0
        self.number5Label.layer.cornerRadius = self.number5Label.frame.width / 2.0
        self.number6Label.layer.cornerRadius = self.number6Label.frame.width / 2.0
        self.bonusNumberLabel.layer.cornerRadius = self.bonusNumberLabel.frame.width / 2.0
    }
}

