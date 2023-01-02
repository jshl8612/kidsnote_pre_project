//
//  PDFView.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit
import FlexLayout
import WebKit

class PDFView: UIView {

    fileprivate let container = UIView()
    lazy var webView: WKWebView = {
        WKWebView()
    }()
    
    init(url: URL) {
        super.init(frame: .zero)
        backgroundColor = .white
        
        container.flex.define { flex in
            flex.addItem(webView).height(100%)
        }
        webView.load(URLRequest(url: url))
        addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
