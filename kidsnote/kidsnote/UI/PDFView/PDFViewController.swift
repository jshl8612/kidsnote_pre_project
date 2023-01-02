//
//  PDFViewController.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import UIKit

class PDFViewController: UIViewController {
    fileprivate var pdfView: PDFView {
        return self.view as! PDFView
    }
    var volume: VolumeItem
    
    init(volume: VolumeItem) {
        self.volume = volume
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        title = volume.volumeInfo?.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        if let link = volume.volumeInfo?.previewLink, let url = URL(string: link) {
            view = PDFView(url: url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
