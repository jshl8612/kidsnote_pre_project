//
//  HomeView.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit
import FlexLayout

class HomeView: UIView {
    fileprivate let container = UIView()
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    fileprivate var items: [VolumeItem] = []
    
    init() {
        super.init(frame: .zero)
        
        container.flex.define { flex in
            flex.addItem(searchBar).height(40)
            flex.addItem(tableView).all(0)
        }
        
        addSubview(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.flex.layout()
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VolumeItemCell.reuseIdentifier, for: indexPath) as! VolumeItemCell
        cell.configure(volume: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
