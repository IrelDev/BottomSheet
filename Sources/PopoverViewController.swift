//
//  PopoverViewController.swift
//  BottomSheet
//
//  Created by Kirill Pustovalov on 25.08.2020.
//

import Foundation
import UIKit

class PopoverViewController: UIViewController {
    public var viewController: UIViewController? {
        didSet {
            viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    public var handlerView: UIView = {
        let handlerView = UIView()
        handlerView.translatesAutoresizingMaskIntoConstraints = false
        handlerView.layer.cornerRadius = 3
        handlerView.backgroundColor = #colorLiteral(red: 0.4454996586, green: 0.4454996586, blue: 0.4454996586, alpha: 1)
        
        return handlerView
    }()
    public var handlerTapAreaView: UIView = {
        let handlerTapAreaView = UIView()
        handlerTapAreaView.translatesAutoresizingMaskIntoConstraints = false
        handlerTapAreaView.backgroundColor = .clear
        
        return handlerTapAreaView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = #colorLiteral(red: 0.4454996586, green: 0.4454996586, blue: 0.4454996586, alpha: 1)
        }
        setupViews()
        setupAutoLayout()
    }
    func setupViews() {
        guard let viewController = viewController else { return }
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        view.addSubview(handlerTapAreaView)
        handlerTapAreaView.addSubview(handlerView)
    }
    func setupAutoLayout() {
        guard let viewController = viewController else { return }
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: handlerTapAreaView.bottomAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            handlerTapAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            handlerTapAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            handlerTapAreaView.topAnchor.constraint(equalTo: view.topAnchor),
            handlerTapAreaView.heightAnchor.constraint(equalToConstant: 45)
        ])
        NSLayoutConstraint.activate([
            handlerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handlerView.centerYAnchor.constraint(equalTo: handlerTapAreaView.centerYAnchor),
            handlerView.heightAnchor.constraint(equalToConstant: 6),
            handlerView.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}
