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
    
    //MARK: events
    ///The action to put functionality when view cover the content
    public var onAction: ((_ onFinish: @escaping () -> Void) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .fullScreen
        
//        self.onAction() {
//            self.dismiss(animated: true, completion: nil)
//        }
        // Do any additional setup after loading the view.
    }
}
