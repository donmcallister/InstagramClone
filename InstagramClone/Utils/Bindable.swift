//
//  Bindable.swift
//  InstagramClone
//
//  Created by Donald McAllister on 12/15/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) ->())?
    
    func bind(observer: @escaping (T?) ->()) {   //to ensure observer called
        self.observer = observer
    }
}
