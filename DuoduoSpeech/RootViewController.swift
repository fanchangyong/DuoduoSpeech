//
//  ViewController.swift
//  DuoduoSpeech
//
//  Created by fancy on 4/13/21.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let homeViewController = HomeViewController()
        self.addChild(homeViewController)
        view.addSubview(homeViewController.view)
        homeViewController.didMove(toParent: self)
        // self.view.addSubview(HomeViewController().view)
    }
    
    @objc func onTouch() {
        print("on touch")
    }

}

