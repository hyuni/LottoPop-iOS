//
//  NLottoWinResultVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 30..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - NLottoWinResultVC
class NLottoWinResultVC: UIViewController {
    // Constant
    static let WIN_RESULT_WEB_URL = SERVER_URL + "/gameResult.do?method=byWin&drwNo="
    
    // MARK: Outlet
    @IBOutlet weak var number1Label: UILabel!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var number3Label: UILabel!
    @IBOutlet weak var number4Label: UILabel!
    @IBOutlet weak var number5Label: UILabel!
    @IBOutlet weak var number6Label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal var nLottoModel = NLottoModel()
    internal var nextDrwNo = 0
    internal var isLoading = false
    internal var autoRequestCount = 0
    internal var winResultList = Array<NLottoWinResult>()
    internal var indicator: UIActivityIndicatorView? = nil
    internal var refreshControl = UIRefreshControl()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "나눔로또6/45"
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        self.initRecommendView()
        self.initTableView()
        
        self.indicator?.startAnimating()
        self.refreshData(nil)
        self.getRecommendationNumbers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.nLottoModel.save()
    }
    
    internal func initRecommendView() {
        self.number1Label.layer.cornerRadius = self.number1Label.frame.width / 2.0
        self.number2Label.layer.cornerRadius = self.number2Label.frame.width / 2.0
        self.number3Label.layer.cornerRadius = self.number3Label.frame.width / 2.0
        self.number4Label.layer.cornerRadius = self.number4Label.frame.width / 2.0
        self.number5Label.layer.cornerRadius = self.number5Label.frame.width / 2.0
        self.number6Label.layer.cornerRadius = self.number6Label.frame.width / 2.0
    }
    
    internal func initTableView() {
        let nLottoCellNib = UINib(nibName: "NLottoTableViewCell", bundle: .main)
        self.tableView.register(nLottoCellNib, forCellReuseIdentifier: "NLottoTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(NLottoWinResultVC.refreshData(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
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
    
    @IBAction func pressedRecommendButton(_ sender: UIButton) {
        self.getRecommendationNumbers()
    }
}

// MARK: - Function
extension NLottoWinResultVC {
    func getRecommendationNumbers() {
        weak var weakSelf = self
        DispatchQueue.global().async {
            let numbers = self.nLottoModel.getRecommendationNumbers()
            DispatchQueue.main.async {
                weakSelf?.number1Label.text = String(numbers[0])
                weakSelf?.number2Label.text = String(numbers[1])
                weakSelf?.number3Label.text = String(numbers[2])
                weakSelf?.number4Label.text = String(numbers[3])
                weakSelf?.number5Label.text = String(numbers[4])
                weakSelf?.number6Label.text = String(numbers[5])
                
                weakSelf?.number1Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[0]))
                weakSelf?.number2Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[1]))
                weakSelf?.number3Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[2]))
                weakSelf?.number4Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[3]))
                weakSelf?.number5Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[4]))
                weakSelf?.number6Label.backgroundColor = UiUtil.getNLottoNumberColor(number: Int16(numbers[5]))
            }
        }
    }
    
    @objc func refreshData(_ sender: UIRefreshControl?) {
        self.isLoading = true
        self.getLatestWinResult()
    }
    
    func commonCompletion() {
        self.nLottoModel.save()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.indicator?.stopAnimating()
        self.isLoading = false
    }
    
    func getWinResult() {
        self.nLottoModel.getWinResult(drwNo: self.nextDrwNo, success: { (winResult) in
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
                self.commonCompletion()
            }
        }) { (errMsg) in
            self.commonCompletion()
            if nil != errMsg {
                MessageUtil.showToast(text: errMsg, parentView: self.view)
            }
        }
    }
    
    func getLatestWinResult() {
        self.nLottoModel.getLatestWinResult(success: { (winResult) in
            self.winResultList.removeAll()
            if nil != winResult {
                self.winResultList.append(winResult!)
                self.nextDrwNo = winResult!.drwNo - 1
                self.autoRequestCount += 1
                self.getWinResult()
            } else {
                self.commonCompletion()
            }
        }) { (errMsg) in
            self.commonCompletion()
            if nil != errMsg {
                MessageUtil.showToast(text: errMsg, parentView: self.view)
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
        let nLottoCell = tableView.dequeueReusableCell(withIdentifier: "NLottoTableViewCell") as! NLottoTableViewCell
        nLottoCell.setTitleData(
            drwNo: winResult.drwNo,
            drwNoDate: winResult.drwNoDate
        )
        
        nLottoCell.setResultData(
            firstPrzwnerCo: winResult.firstPrzwnerCo,
            firstWinamnt: winResult.firstWinamnt
        )
        
        nLottoCell.setNumberData(
            drwtNo1: winResult.drwtNo1,
            drwtNo2: winResult.drwtNo2,
            drwtNo3: winResult.drwtNo3,
            drwtNo4: winResult.drwtNo4,
            drwtNo5: winResult.drwtNo5,
            drwtNo6: winResult.drwtNo6,
            bnusNo: winResult.bnusNo
        )
        return nLottoCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if 0 >= self.nextDrwNo || true == self.isLoading || false == NetStatusUtil.shared.canConnectToInternet() {
            return
        }
        
        if indexPath.row == self.winResultList.count - 1 {
            self.isLoading = true
            self.autoRequestCount = 0
            self.indicator?.startAnimating()
            self.getWinResult()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "NLottoWinResultVC to WebVC", sender: nil)
    }
}
