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
    
    fileprivate lazy var authorLabel: UILabel = {
       UILabel()
    }()
    
    fileprivate lazy var kindLabel: UILabel = {
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

        contentView.flex.direction(.row).padding(12).define { (flex) in
            flex.addItem(thumbImageView).size(CGSize(width: 65, height: 95))
            flex.addItem().marginLeft(12).define { flex in
                flex.addItem(nameLabel)
                flex.addItem(authorLabel).marginTop(5)
                flex.addItem(kindLabel)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(volume: VolumeItem) {
        nameLabel.text = volume.volumeInfo?.title
        nameLabel.flex.markDirty()
        
        authorLabel.text = volume.volumeInfo?.authors?.first
        authorLabel.flex.markDirty()
        
        kindLabel.text = volume.kind
        kindLabel.flex.markDirty()
        
        Task {
            do {
                if let link = volume.volumeInfo?.imageLinks?.smallThumbnail,
                    let url = URL(string: link) {
                    thumbImageView.image = try await ImageLoader().fetch(url)
                }
            }
            catch {
                print(error)
            }
        }
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
