//
//  PLottoTableViewCell.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 28..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class PLottoTableViewCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet weak var titleRoundLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultAmountLabel: UILabel!
    @IBOutlet weak var group1Label: UILabel!
    @IBOutlet weak var num1_1Label: UILabel!
    @IBOutlet weak var num1_2Label: UILabel!
    @IBOutlet weak var num1_3Label: UILabel!
    @IBOutlet weak var num1_4Label: UILabel!
    @IBOutlet weak var num1_5Label: UILabel!
    @IBOutlet weak var num1_6Label: UILabel!
    @IBOutlet weak var group2Label: UILabel!
    @IBOutlet weak var num2_1Label: UILabel!
    @IBOutlet weak var num2_2Label: UILabel!
    @IBOutlet weak var num2_3Label: UILabel!
    @IBOutlet weak var num2_4Label: UILabel!
    @IBOutlet weak var num2_5Label: UILabel!
    @IBOutlet weak var num2_6Label: UILabel!

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.group1Label.layer.cornerRadius = 4.0
        self.num1_1Label.layer.cornerRadius = 4.0
        self.num1_2Label.layer.cornerRadius = 4.0
        self.num1_3Label.layer.cornerRadius = 4.0
        self.num1_4Label.layer.cornerRadius = 4.0
        self.num1_5Label.layer.cornerRadius = 4.0
        self.num1_6Label.layer.cornerRadius = 4.0
        self.group2Label.layer.cornerRadius = 4.0
        self.num2_1Label.layer.cornerRadius = 4.0
        self.num2_2Label.layer.cornerRadius = 4.0
        self.num2_3Label.layer.cornerRadius = 4.0
        self.num2_4Label.layer.cornerRadius = 4.0
        self.num2_5Label.layer.cornerRadius = 4.0
        self.num2_6Label.layer.cornerRadius = 4.0
    }
}
