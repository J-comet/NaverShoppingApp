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
    
    let networkErrorView = UIView().setup { view in
        view.backgroundColor = ResColors.mainBg
        view.isHidden = true
    }
    
    private lazy var reloadView = ClickableView().setup { view in
        view.onClick = { [weak self] in
            self?.reloadViewClicked?()
        }
    }
    
    private let reloadImageView = UIImageView(frame: .zero).setup { view in
        view.image = UIImage(systemName: "arrow.counterclockwise.icloud")
        view.tintColor = ResColors.placeHolder
    }
    
    private let reloadLabel = UILabel().setup { view in
        view.text = ResStrings.Guide.webViewReload
        view.textColor = ResColors.primaryLabel
        view.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
    }
    
    var reloadViewClicked: (() -> Void)?
    
    override func configureView() {
        addSubview(webView)
        addSubview(networkErrorView)
        networkErrorView.addSubview(reloadView)
        reloadView.addSubview(reloadImageView)
        reloadView.addSubview(reloadLabel)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        networkErrorView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        reloadView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(4)
        }
        
        reloadImageView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(60)
            make.center.equalToSuperview()
        }
        
        reloadLabel.snp.makeConstraints { make in
            make.top.equalTo(reloadImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
}
