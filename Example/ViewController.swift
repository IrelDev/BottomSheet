//
//  ViewController.swift
//  Example
//
//  Created by Kirill Pustovalov on 25.08.2020.
//

import UIKit
import BottomSheet

class ViewController: BottomSheetViewController {
    private let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.textAlignment = .center
        label.text = "Drag the handler!"
        label.backgroundColor = .purple
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    override func viewDidLoad() {
        label.center = view.center
        view.addSubview(label)
        
        isHalfPresentationEnabled = false
        viewController = BottomSheetContentsViewController()
        super.viewDidLoad()
    }
}

