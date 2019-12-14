//
//  SignUpVC.swift
//  InstagramClone
//
//  Created by Donald McAllister on 12/14/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
