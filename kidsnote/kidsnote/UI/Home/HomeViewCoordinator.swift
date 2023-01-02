//
//  HomeViewCoordinator.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit

final class HomeViewCoordinator {
    var navigationController: UINavigationController
    init(_ navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushToPdfView(volume: VolumeItem) {
        let pdfView = PDFViewController(volume: volume)
        self.navigationController.pushViewController(pdfView, animated: true)
    }
}
