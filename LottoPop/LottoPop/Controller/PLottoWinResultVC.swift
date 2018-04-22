//
//  PLottoWinResultVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 30..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - PLottoWinResultVC
class PLottoWinResultVC: UIViewController {
    // MARK: Constant
    static let WIN_RESULT_WEB_URL = SERVER_URL + "/gameResult.do?method=win520&Round="
    
    // MARK: Outlet
    @IBOutlet weak var group1Label: UILabel!
    @IBOutlet weak var group2Label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    internal let pLottoModel = PLottoModel()
    internal var nextRound = 0
    internal var isLoading = false
    internal var autoRequestCount = 0
    internal var winResultList = Array<[PLottoWinResult]>()
    internal var indicator: UIActivityIndicatorView? = nil
    internal var refreshControl = UIRefreshControl()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "연금복권520"
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        self.initRecommendView()
        self.initTableView()
        
        self.indicator?.startAnimating()
        self.refreshData(nil)
        self.getRecommendationNumbers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pLottoModel.save()
    }
    
    internal func initRecommendView() {
        self.group1Label.layer.cornerRadius = 4.0
        self.group2Label.layer.cornerRadius = 4.0
    }
    
    internal func initTableView() {
        let pLottoCellNib = UINib(nibName: "PLottoTableViewCell", bundle: .main)
        self.tableView.register(pLottoCellNib, forCellReuseIdentifier: "PLottoTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refreshControl.addTarget(self, action: #selector(PLottoWinResultVC.refreshData(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
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
    
    @IBAction func pressedRecommendButton(_ sender: UIButton) {
        self.getRecommendationNumbers()
    }
}

// MARK: - Function
extension PLottoWinResultVC {
    func getRecommendationNumbers() {
        weak var weakSelf = self
        DispatchQueue.global().async {
            let numbers = self.pLottoModel.getRecommendationNumbers()
            DispatchQueue.main.async {
                weakSelf?.group1Label.text = String(numbers[0])
                weakSelf?.group2Label.text = String(numbers[1])
                
                weakSelf?.group1Label.backgroundColor = UiUtil.getPLottoGroupColor(number: numbers[0])
                weakSelf?.group2Label.backgroundColor = UiUtil.getPLottoGroupColor(number: numbers[1])
            }
        }
    }
    
    @objc func refreshData(_ sender: UIRefreshControl?) {
        self.isLoading = true
        self.getLatestWinResult()
    }
    
    func commonCompletion() {
        self.pLottoModel.save()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        self.indicator?.stopAnimating()
        self.isLoading = false
    }
    
    func getWinResult() {
        self.pLottoModel.getWinResult(round: self.nextRound, success: { (winResultArr) in
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
        self.pLottoModel.getLatestWinResult(success: { (winResultArr) in
            self.winResultList.removeAll()
            self.winResultList.append(winResultArr!)
            if let roundStr = winResultArr?[0].round, let round = Int(roundStr) {
                self.nextRound = round - 1
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
extension PLottoWinResultVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.winResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pLottoCell = tableView.dequeueReusableCell(withIdentifier: "PLottoTableViewCell") as! PLottoTableViewCell
        pLottoCell.resetCell()
        
        let winResultArr = self.winResultList[indexPath.row]
        if 1 <= winResultArr.count {
            let winResult = winResultArr[0]
            
            pLottoCell.setTitleData(
                round: winResult.round,
                pensionDrawDate: winResult.pensionDrawDate
            )
            
            pLottoCell.setResultData(gameCount: winResultArr.count)
            
            var rankNo = winResult.rankNo
            let num1 = rankNo?.removeFirst()
            let num2 = rankNo?.removeFirst()
            let num3 = rankNo?.removeFirst()
            let num4 = rankNo?.removeFirst()
            let num5 = rankNo?.removeFirst()
            let num6 = rankNo?.removeFirst()
            pLottoCell.setNumberGroup1Data(
                rankClass: winResult.rankClass,
                num1: (nil != num1) ? String(num1!) : "",
                num2: (nil != num2) ? String(num2!) : "",
                num3: (nil != num3) ? String(num3!) : "",
                num4: (nil != num4) ? String(num4!) : "",
                num5: (nil != num5) ? String(num5!) : "",
                num6: (nil != num6) ? String(num6!) : ""
            )
        }
        if 2 <= winResultArr.count {
            let winResult = winResultArr[1]
            
            var rankNo = winResult.rankNo
            let num1 = rankNo?.removeFirst()
            let num2 = rankNo?.removeFirst()
            let num3 = rankNo?.removeFirst()
            let num4 = rankNo?.removeFirst()
            let num5 = rankNo?.removeFirst()
            let num6 = rankNo?.removeFirst()
            pLottoCell.setNumberGroup2Data(
                rankClass: winResult.rankClass,
                num1: (nil != num1) ? String(num1!) : "",
                num2: (nil != num2) ? String(num2!) : "",
                num3: (nil != num3) ? String(num3!) : "",
                num4: (nil != num4) ? String(num4!) : "",
                num5: (nil != num5) ? String(num5!) : "",
                num6: (nil != num6) ? String(num6!) : ""
            )
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
            self.indicator?.startAnimating()
            self.getWinResult()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PLottoWinResultVC to WebVC", sender: nil)
    }
}
