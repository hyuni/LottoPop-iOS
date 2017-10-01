//
//  MainVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

// MARK: - Base
class MainVC: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal let nLottoModel = NLottoModel()
    internal let pLottoModel = PLottoModel()
    internal var nLottoWinResult: NLottoWinResult? = nil
    internal var pLottoWinResult: Array<PLottoWinResult>? = nil
    internal var indicator: UIActivityIndicatorView? = nil
    internal var barcodeValue: String? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "로또팝"
        self.initRightMenu()
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        
        let nLottoCellNib = UINib(nibName: "NLottoTableViewCell", bundle: .main)
        let pLottoCellNib = UINib(nibName: "PLottoTableViewCell", bundle: .main)
        self.tableView.register(nLottoCellNib, forCellReuseIdentifier: "NLottoTableViewCell")
        self.tableView.register(pLottoCellNib, forCellReuseIdentifier: "PLottoTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.indicator?.startAnimating()
        self.nLottoModel.getLatestWinResult { (winResult, nLottoError) in
            if nil != winResult {
                self.nLottoWinResult = winResult
                self.nLottoModel.save()
            } else {
                MessageUtil.showToast(text: "나눔로또 정보를 가져오지 못했습니다.", parentView: self.view)
            }

            self.pLottoModel.getLatestWinResult { (winResultArr, pLottoError) in
                if nil != winResultArr {
                    self.pLottoWinResult = winResultArr
                    self.nLottoModel.save()
                } else {
                    MessageUtil.showToast(text: "연금복권 정보를 가져오지 못했습니다.", parentView: self.view)
                }
                self.tableView.reloadData()
                self.indicator?.stopAnimating()
            }
        }
    }
}

// MARK: - Event
extension MainVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is NLottoWinResultVC, is PLottoWinResultVC:
            if let selected = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selected, animated: false)
            }
            break
            
        case is BarcodeReaderVC:
            let barcodeReaderVC = segue.destination as! BarcodeReaderVC
            barcodeReaderVC.delegate = self
            break
            
        case is WebVC:
            let webVC = segue.destination as! WebVC
            webVC.title = "당첨결과"
            webVC.urlStr = self.barcodeValue
            break
            
        default:
            break
        }
    }
}

// MARK: - Function
extension MainVC {
    internal func initRightMenu() {
        let scanQrBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25.0, height: 25.0))
        scanQrBtn.setImage(UIImage(named: "prangbi_qr_code"), for: .normal)
        scanQrBtn.addTarget(self, action: #selector(MainVC.scanQrCode), for: .touchUpInside)
        let scanQrItem = UIBarButtonItem(customView: scanQrBtn)
        self.navigationItem.rightBarButtonItems = [scanQrItem]
    }
    
    @objc func scanQrCode() {
        self.performSegue(withIdentifier: "MainVC to BarcodeReaderVC", sender: nil)
    }
}

// MARK: - UITableView
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            let nLottoCell = tableView.dequeueReusableCell(withIdentifier: "NLottoTableViewCell") as! NLottoTableViewCell
            if let winResult = self.nLottoWinResult {
                let firstWinAmount = Util.amountString(amount: winResult.firstWinamnt) ?? ""
                nLottoCell.titleDrwNoLabel.text = String(winResult.drwNo)
                nLottoCell.titleLabel.text = "나눔로또6/45"
                nLottoCell.titleDateLabel.text = "(" + (winResult.drwNoDate ?? "") + ")"
                nLottoCell.resultLabel.text = "1등 " + String(winResult.firstPrzwnerCo) + "게임"
                nLottoCell.resultAmountLabel.text = "게임당 " + firstWinAmount + "원"
                
                nLottoCell.number1Label.text = String(winResult.drwtNo1)
                nLottoCell.number2Label.text = String(winResult.drwtNo2)
                nLottoCell.number3Label.text = String(winResult.drwtNo3)
                nLottoCell.number4Label.text = String(winResult.drwtNo4)
                nLottoCell.number5Label.text = String(winResult.drwtNo5)
                nLottoCell.number6Label.text = String(winResult.drwtNo6)
                nLottoCell.bonusNumberLabel.text = String(winResult.bnusNo)
                
                nLottoCell.number1Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo1)
                nLottoCell.number2Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo2)
                nLottoCell.number3Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo3)
                nLottoCell.number4Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo4)
                nLottoCell.number5Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo5)
                nLottoCell.number6Label.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.drwtNo6)
                nLottoCell.bonusNumberLabel.backgroundColor = UiUtil.getNLottoNumberColor(number: winResult.bnusNo)
            } else {
                nLottoCell.titleDrwNoLabel.text = nil
                nLottoCell.titleLabel.text = nil
                nLottoCell.titleDateLabel.text = nil
                nLottoCell.resultLabel.text = nil
                nLottoCell.resultAmountLabel.text = nil
                nLottoCell.number1Label.text = nil
                nLottoCell.number2Label.text = nil
                nLottoCell.number3Label.text = nil
                nLottoCell.number4Label.text = nil
                nLottoCell.number5Label.text = nil
                nLottoCell.number6Label.text = nil
                nLottoCell.bonusNumberLabel.text = nil
            }
            return nLottoCell
        } else if 1 == indexPath.row {
            let pLottoCell = tableView.dequeueReusableCell(withIdentifier: "PLottoTableViewCell") as! PLottoTableViewCell
            pLottoCell.titleRoundLabel.text = nil
            pLottoCell.titleLabel.text = nil
            pLottoCell.titleDateLabel.text = nil
            pLottoCell.resultLabel.text = nil
            pLottoCell.resultAmountLabel.text = nil
            pLottoCell.group1Label.text = nil
            pLottoCell.num1_1Label.text = nil
            pLottoCell.num1_2Label.text = nil
            pLottoCell.num1_3Label.text = nil
            pLottoCell.num1_4Label.text = nil
            pLottoCell.num1_5Label.text = nil
            pLottoCell.num1_6Label.text = nil
            pLottoCell.group2Label.text = nil
            pLottoCell.num2_1Label.text = nil
            pLottoCell.num2_2Label.text = nil
            pLottoCell.num2_3Label.text = nil
            pLottoCell.num2_4Label.text = nil
            pLottoCell.num2_5Label.text = nil
            pLottoCell.num2_6Label.text = nil
            
            if let winResultArr = self.pLottoWinResult {
                if 1 <= winResultArr.count {
                    let winResult = winResultArr[0]
                    let rankClass = (nil != winResult.rankClass) ? (Int(winResult.rankClass!) ?? 0) : 0
                    var rankNoCharacters = winResult.rankNo?.characters
                    let num1 = rankNoCharacters?.removeFirst()
                    let num2 = rankNoCharacters?.removeFirst()
                    let num3 = rankNoCharacters?.removeFirst()
                    let num4 = rankNoCharacters?.removeFirst()
                    let num5 = rankNoCharacters?.removeFirst()
                    let num6 = rankNoCharacters?.removeFirst()
                    
                    pLottoCell.titleRoundLabel.text = winResult.round
                    pLottoCell.titleLabel.text = "연금복권520"
                    pLottoCell.titleDateLabel.text = "(" + (winResult.pensionDrawDate ?? "") + ")"
                    pLottoCell.resultLabel.text = "1등 " + String(winResultArr.count) + "게임"
                    pLottoCell.resultAmountLabel.text = "월 500만원 X 20년"
                    
                    pLottoCell.group1Label.text = (winResult.rankClass ?? "") + "조"
                    pLottoCell.num1_1Label.text = (nil != num1) ? String(num1!) : ""
                    pLottoCell.num1_2Label.text = (nil != num2) ? String(num2!) : ""
                    pLottoCell.num1_3Label.text = (nil != num3) ? String(num3!) : ""
                    pLottoCell.num1_4Label.text = (nil != num4) ? String(num4!) : ""
                    pLottoCell.num1_5Label.text = (nil != num5) ? String(num5!) : ""
                    pLottoCell.num1_6Label.text = (nil != num6) ? String(num6!) : ""
                    
                    pLottoCell.group1Label.backgroundColor = UiUtil.getPLottoGroupColor(number: rankClass)
                }
                if 2 <= winResultArr.count {
                    let winResult = winResultArr[1]
                    let rankClass = (nil != winResult.rankClass) ? (Int(winResult.rankClass!) ?? 0) : 0
                    var rankNoCharacters = winResult.rankNo?.characters
                    let num1 = rankNoCharacters?.removeFirst()
                    let num2 = rankNoCharacters?.removeFirst()
                    let num3 = rankNoCharacters?.removeFirst()
                    let num4 = rankNoCharacters?.removeFirst()
                    let num5 = rankNoCharacters?.removeFirst()
                    let num6 = rankNoCharacters?.removeFirst()

                    pLottoCell.group2Label.text = (winResult.rankClass ?? "") + "조"
                    pLottoCell.num2_1Label.text = (nil != num1) ? String(num1!) : ""
                    pLottoCell.num2_2Label.text = (nil != num2) ? String(num2!) : ""
                    pLottoCell.num2_3Label.text = (nil != num3) ? String(num3!) : ""
                    pLottoCell.num2_4Label.text = (nil != num4) ? String(num4!) : ""
                    pLottoCell.num2_5Label.text = (nil != num5) ? String(num5!) : ""
                    pLottoCell.num2_6Label.text = (nil != num6) ? String(num6!) : ""
                    
                    pLottoCell.group2Label.backgroundColor = UiUtil.getPLottoGroupColor(number: rankClass)
                }
            }
            return pLottoCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 == indexPath.row {
            self.performSegue(withIdentifier: "MainVC to NLottoWinResultVC", sender: nil)
        } else if 1 == indexPath.row {
            self.performSegue(withIdentifier: "MainVC to PLottoWinResultVC", sender: nil)
        }
    }
}

// MARK:
extension MainVC: BarcodeReaderVcDelegate {
    func barcodeReaderVC(sender: BarcodeReaderVC, didRead value: String?) {
        self.barcodeValue = value
        self.navigationController?.popViewController(animated: true)
        if nil != value {
            self.performSegue(withIdentifier: "MainVC to WebVC", sender: nil)
        } else {
            MessageUtil.showToast(text: "바코드를 읽지 못했습니다.", parentView: self.view)
        }
    }
}
