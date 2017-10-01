//
//  PLottoTableViewCell.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 28..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - PLottoTableViewCell
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

// MARK: - Function
extension PLottoTableViewCell {
    func resetCell() {
        self.titleRoundLabel.text = nil
        self.titleLabel.text = nil
        self.titleDateLabel.text = nil
        
        self.resultLabel.text = nil
        self.resultAmountLabel.text = nil
        
        self.group1Label.text = nil
        self.num1_1Label.text = nil
        self.num1_2Label.text = nil
        self.num1_3Label.text = nil
        self.num1_4Label.text = nil
        self.num1_5Label.text = nil
        self.num1_6Label.text = nil
        
        self.group2Label.text = nil
        self.num2_1Label.text = nil
        self.num2_2Label.text = nil
        self.num2_3Label.text = nil
        self.num2_4Label.text = nil
        self.num2_5Label.text = nil
        self.num2_6Label.text = nil
        
        self.group1Label.backgroundColor = nil
        self.group2Label.backgroundColor = nil
    }
    
    func setTitleData(round: String?, pensionDrawDate: String?) {
        self.titleRoundLabel.text = round
        self.titleLabel.text = "연금복권520"
        self.titleDateLabel.text = "(" + (pensionDrawDate ?? "") + ")"
    }
    
    func setResultData(gameCount: Int) {
        self.resultLabel.text = "1등 " + String(gameCount) + "게임"
        self.resultAmountLabel.text = "월 500만원 X 20년"
    }
    
    func setNumberGroup1Data(
        rankClass: String?,
        num1: String?,
        num2: String?,
        num3: String?,
        num4: String?,
        num5: String?,
        num6: String?)
    {
        let rankClassInt = (nil != rankClass) ? (Int(rankClass!) ?? 0) : 0
        
        self.group1Label.text = (rankClass ?? "") + "조"
        self.num1_1Label.text = num1 ?? ""
        self.num1_2Label.text = num2 ?? ""
        self.num1_3Label.text = num3 ?? ""
        self.num1_4Label.text = num4 ?? ""
        self.num1_5Label.text = num5 ?? ""
        self.num1_6Label.text = num6 ?? ""
        
        self.group1Label.backgroundColor = UiUtil.getPLottoGroupColor(number: rankClassInt)
    }
    
    func setNumberGroup2Data(
        rankClass: String?,
        num1: String?,
        num2: String?,
        num3: String?,
        num4: String?,
        num5: String?,
        num6: String?)
    {
        let rankClassInt = (nil != rankClass) ? (Int(rankClass!) ?? 0) : 0
        
        self.group2Label.text = (rankClass ?? "") + "조"
        self.num2_1Label.text = num1 ?? ""
        self.num2_2Label.text = num2 ?? ""
        self.num2_3Label.text = num3 ?? ""
        self.num2_4Label.text = num4 ?? ""
        self.num2_5Label.text = num5 ?? ""
        self.num2_6Label.text = num6 ?? ""
        
        self.group2Label.backgroundColor = UiUtil.getPLottoGroupColor(number: rankClassInt)
    }
}
