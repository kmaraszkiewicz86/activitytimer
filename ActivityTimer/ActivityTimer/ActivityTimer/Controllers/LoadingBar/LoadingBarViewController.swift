//
//  LoadingBarViewController.swift
//  ActivityTimer
//
//  Created by Krzysztof Maraszkiewicz on 17/07/2019.
//  Copyright © 2019 Krzysztof Maraszkiewicz. All rights reserved.
//

import UIKit

class LoadingBarViewController: UIViewController {

    //MARK: outlets
    ///The loader bar outlet
    @IBOutlet weak var loaderBar: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderBar.startAnimating()
    }
    
    ///Close view controller
    public func close() {
        self.dismiss(animated: false, completion: nil)
    }
}
