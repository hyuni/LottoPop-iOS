//
//  NLottoTableViewCell.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 28..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - NLottoTableViewCell
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

// MARK: - Function
extension NLottoTableViewCell {
    func resetCell() {
        self.titleDrwNoLabel.text = nil
        self.titleLabel.text = nil
        self.titleDateLabel.text = nil
        self.resultLabel.text = nil
        self.resultAmountLabel.text = nil
        self.number1Label.text = nil
        self.number2Label.text = nil
        self.number3Label.text = nil
        self.number4Label.text = nil
        self.number5Label.text = nil
        self.number6Label.text = nil
        self.bonusNumberLabel.text = nil
    }
    
    func setTitleData(
        drwNo: Int,
        drwNoDate: String?)
    {
        self.titleDrwNoLabel.text = String(drwNo)
        self.titleLabel.text = "나눔로또6/45"
        self.titleDateLabel.text = "(" + (drwNoDate ?? "") + ")"
    }
    
    func setResultData(
        firstPrzwnerCo: Int32,
        firstWinamnt: Int64)
    {
        let firstWinAmount = Util.amountString(amount: firstWinamnt) ?? ""
        
        self.resultLabel.text = "1등 " + String(firstPrzwnerCo) + "게임"
        self.resultAmountLabel.text = "게임당 " + firstWinAmount + "원"
    }
    
    func setNumberData(
        drwtNo1: Int16,
        drwtNo2: Int16,
        drwtNo3: Int16,
        drwtNo4: Int16,
        drwtNo5: Int16,
        drwtNo6: Int16,
        bnusNo: Int16)
    {
        self.number1Label.text = String(drwtNo1)
        self.number2Label.text = String(drwtNo2)
        self.number3Label.text = String(drwtNo3)
        self.number4Label.text = String(drwtNo4)
        self.number5Label.text = String(drwtNo5)
        self.number6Label.text = String(drwtNo6)
        self.bonusNumberLabel.text = String(bnusNo)
        
        self.number1Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo1)
        self.number2Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo2)
        self.number3Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo3)
        self.number4Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo4)
        self.number5Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo5)
        self.number6Label.backgroundColor = UiUtil.getNLottoNumberColor(number: drwtNo6)
        self.bonusNumberLabel.backgroundColor = UiUtil.getNLottoNumberColor(number: bnusNo)
    }
}
