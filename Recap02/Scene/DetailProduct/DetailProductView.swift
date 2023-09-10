//
//  DetailProductView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import WebKit
import BaseKit
import SnapKit

final class DetailProductView: BaseView {
    
    // 배경색 지정안해주고 navigator.push 화면전환시 버벅이는 문제발생
    override var viewBg: UIColor { ResColors.mainBg }
    
    var webView = WKWebView()
    
    override func configureView() {
        addSubview(webView)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
