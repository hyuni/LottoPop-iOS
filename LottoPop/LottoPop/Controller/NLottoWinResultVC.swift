//
//  NLottoWinResultVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 30..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class NLottoWinResultVC: UIViewController {
    // Constant
    static let WIN_RESULT_WEB_URL = SERVER_URL + "/gameResult.do?method=byWin&drwNo="
    
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal var nLottoModel = NLottoModel()
    internal var nextDrwNo = 0
    internal var isLoading = false
    internal var autoRequestCount = 0
    internal var winResultList = Array<NLottoWinResult>()
    internal var indicator: UIActivityIndicatorView? = nil

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "나눔로또6/45"
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        
        let nLottoCellNib = UINib(nibName: "NLottoTableViewCell", bundle: .main)
        self.tableView.register(nLottoCellNib, forCellReuseIdentifier: "NLottoTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.isLoading = true
        self.nextDrwNo = 0
        self.autoRequestCount = 0
        self.getWinResult()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.nLottoModel.save()
    }
}

// MARK: - Event
extension NLottoWinResultVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is WebVC:
            let webVC = segue.destination as! WebVC
            if let selected = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selected, animated: false)
                
                let winResult = self.winResultList[selected.row]
                webVC.title = "당첨결과"
                webVC.urlStr = NLottoWinResultVC.WIN_RESULT_WEB_URL + String(winResult.drwNo)
            }
            break
            
        default:
            break
        }
    }
}

// MARK: - Function
extension NLottoWinResultVC {
    func getWinResult() {
        self.indicator?.startAnimating()
        self.nLottoModel.getWinResult(drwNo: self.nextDrwNo) { (winResult, error) in
            if nil == error {
                var shouldRequestMore = false
                if nil != winResult {
                    self.winResultList.append(winResult!)
                    self.nextDrwNo = winResult!.drwNo - 1
                    
                    self.autoRequestCount += 1
                    if COUNT_PER_PAGE > self.autoRequestCount && 0 < self.nextDrwNo {
                        shouldRequestMore = true
                    }
                }
                
                if true == shouldRequestMore {
                    self.getWinResult()
                } else {
                    self.nLottoModel.save()
                    self.tableView.reloadData()
                    self.indicator?.stopAnimating()
                    self.isLoading = false
                }
            } else {
                self.nLottoModel.save()
                self.tableView.reloadData()
                self.indicator?.stopAnimating()
                self.isLoading = false
                MessageUtil.showToast(text: error?.localizedDescription, parentView: self.view)
            }
        }
    }
}

// MARK: - UITableView
extension NLottoWinResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.winResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let winResult = self.winResultList[indexPath.row]
        let firstWinAmount = Util.amountString(amount: winResult.firstWinamnt) ?? ""

        let nLottoCell = tableView.dequeueReusableCell(withIdentifier: "NLottoTableViewCell") as! NLottoTableViewCell
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
        return nLottoCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 >= self.nextDrwNo || true == self.isLoading || false == NetStatusUtil.shared.canConnectToInternet() {
            return
        }
        
        if indexPath.row == self.winResultList.count - 1 {
            self.isLoading = true
            self.autoRequestCount = 0
            self.getWinResult()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NLottoWinResultVC to WebVC", sender: nil)
    }
}
