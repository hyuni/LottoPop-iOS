//
//  ToastView.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 9. 2..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class ToastView: UIView {
    // MARK: Outlet
    @IBOutlet weak var label: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 4.0
    }
    
    // MARK: Function
    func setData(text: String?) {
        self.label.text = text
    }
    
    func getSize() -> CGSize {
        var viewSize = self.label.sizeThatFits(CGSize(
            width: Double.greatestFiniteMagnitude,
            height: Double.greatestFiniteMagnitude))
        viewSize.width += 16.0
        viewSize.height += 16.0
        return viewSize
    }
}
