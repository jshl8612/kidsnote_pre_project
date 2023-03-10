//
//  HomeView.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit
import FlexLayout
import RxSwift
import RxCocoa

class HomeView: UIView {
    fileprivate let container = UIView()
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar(frame: .zero)
        bar.searchBarStyle = .default
        bar.returnKeyType = .search
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(VolumeItemCell.self, forCellReuseIdentifier: VolumeItemCell.reuseIdentifier)
        return tableView
    }()
    
    fileprivate var items: [VolumeItem] = []
    private var viewModel = HomeViewModel()
    private let bag = DisposeBag()
    private var coordinator: HomeViewCoordinator
    
    init(coordinator: HomeViewCoordinator) {
        self.coordinator = coordinator
        super.init(frame: .zero)
        backgroundColor = .white
        
        container.flex.define { flex in
            flex.addItem(tableView).height(100%)
        }
        
        addSubview(container)
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBinding() {
        searchBar
            .searchTextField.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchObserver)
            .disposed(by: bag)

        viewModel.content
            .drive(tableView.rx.items(cellIdentifier: VolumeItemCell.reuseIdentifier, cellType: VolumeItemCell.self)) {
                (index, volume: VolumeItem, cell) in
                cell.configure(volume: volume)
            }
            .disposed(by: bag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(VolumeItem.self))
            .bind { [unowned self] indexPath, model in
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.coordinator.pushToPdfView(volume: model)
            }
            .disposed(by: bag)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.pin.top().horizontally().bottom().margin(pin.safeArea)
        container.flex.layout()
        tableView.contentOffset = .zero
    }
}
