//
//  VolumeItemCell.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit
import FlexLayout
import PinLayout

class VolumeItemCell: UITableViewCell {

    static let reuseIdentifier = "VolumeItemCell"
    fileprivate let padding: CGFloat = 10
    
    fileprivate lazy var nameLabel: UILabel = {
       UILabel()
    }()
    
    fileprivate lazy var thumbImageView: UIImageView = {
       UIImageView()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        let iconImageView = UIImageView(image: UIImage(named: "method"))
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.lineBreakMode = .byTruncatingTail

        contentView.flex.padding(12).define { (flex) in
            flex.addItem(thumbImageView).size(30)
            flex.addItem(nameLabel).marginLeft(padding).grow(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }

}
