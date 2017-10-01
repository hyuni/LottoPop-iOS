//
//  PLottoWinResultVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 30..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class PLottoWinResultVC: UIViewController {
    // MARK: Constant
    static let WIN_RESULT_WEB_URL = SERVER_URL + "/gameResult.do?method=win520&Round="
    
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal let pLottoModel = PLottoModel()
    internal var nextRound = 0
    internal var isLoading = false
    internal var autoRequestCount = 0
    internal var winResultList = Array<[PLottoWinResult]>()
    internal var indicator: UIActivityIndicatorView? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "연금복권520"
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        
        let pLottoCellNib = UINib(nibName: "PLottoTableViewCell", bundle: .main)
        self.tableView.register(pLottoCellNib, forCellReuseIdentifier: "PLottoTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.isLoading = true
        self.nextRound = 0
        self.autoRequestCount = 0
        self.getWinResult()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pLottoModel.save()
    }
}

// MARK: - Event
extension PLottoWinResultVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is WebVC:
            let webVC = segue.destination as! WebVC
            if let selected = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selected, animated: false)
                
                let winResult = self.winResultList[selected.row][0]
                webVC.title = "당첨결과"
                webVC.urlStr = PLottoWinResultVC.WIN_RESULT_WEB_URL + (winResult.round ?? "")
            }
            break
            
        default:
            break
        }
    }
}

// MARK: - Function
extension PLottoWinResultVC {
    func getWinResult() {
        self.indicator?.startAnimating()
        self.pLottoModel.getWinResult(round: self.nextRound) { (winResultArr, error) in
            if nil == error {
                var shouldRequestMore = false
                if nil != winResultArr {
                    self.winResultList.append(winResultArr!)
                    if let roundStr = winResultArr?[0].round, let round = Int(roundStr) {
                        self.nextRound = round - 1
                    } else {
                        self.nextRound -= 1
                    }
                    
                    self.autoRequestCount += 1
                    if COUNT_PER_PAGE > self.autoRequestCount && 0 < self.nextRound {
                        shouldRequestMore = true
                    }
                }
                
                if true == shouldRequestMore {
                    self.getWinResult()
                } else {
                    self.pLottoModel.save()
                    self.tableView.reloadData()
                    self.indicator?.stopAnimating()
                    self.isLoading = false
                }
            } else {
                self.pLottoModel.save()
                self.tableView.reloadData()
                self.indicator?.stopAnimating()
                self.isLoading = false
                MessageUtil.showToast(text: error?.localizedDescription, parentView: self.view)
            }
        }
    }
}

// MARK: - UITableView
extension PLottoWinResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.winResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        pLottoCell.group1Label.backgroundColor = nil
        pLottoCell.group2Label.backgroundColor = nil
        
        let winResultArr = self.winResultList[indexPath.row]
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
        return pLottoCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 >= self.nextRound || true == self.isLoading || false == NetStatusUtil.shared.canConnectToInternet() {
            return
        }
        
        if indexPath.row == self.winResultList.count - 1 {
            self.isLoading = true
            self.autoRequestCount = 0
            self.getWinResult()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PLottoWinResultVC to WebVC", sender: nil)
    }
}
