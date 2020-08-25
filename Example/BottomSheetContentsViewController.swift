//
//  BottomSheetContentsViewController.swift
//  Example
//
//  Created by Kirill Pustovalov on 25.08.2020.
//

import Foundation
import UIKit

class BottomSheetContentsViewController: UIViewController {
    private let placeholderImageView: UIImageView = {
        let placeholderImageView = UIImageView(image: UIImage(named: "placeholder"))
        
        placeholderImageView.clipsToBounds = true
        placeholderImageView.layer.cornerRadius = 10
        
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImageView
    }()
    private let playingLabel: UILabel = {
        let playingLabel = UILabel()
        playingLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        playingLabel.text = "Not Playing"
        
        playingLabel.translatesAutoresizingMaskIntoConstraints = false
        return playingLabel
    }()
    private let controlsStackView: UIStackView = {
        let controlsStackView = UIStackView()
        controlsStackView.alignment = .center
        controlsStackView.alignment = .fill
        controlsStackView.spacing = 50
        controlsStackView.distribution = .fillEqually
        
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        return controlsStackView
    }()
    private let playImageView: UIImageView = {
        let playImageView = UIImageView(image: UIImage(systemName: "play.fill"))
        return playImageView
    }()
    private let forwardImageView: UIImageView = {
        let forwardImageView = UIImageView(image: UIImage(systemName: "forward.fill"))
        return forwardImageView
    }()
    private let backwardImageView: UIImageView = {
        let backwardImageView = UIImageView(image: UIImage(systemName: "backward.fill"))
        return backwardImageView
    }()
    private let airPlayImageView: UIImageView = {
        let airPlayImageView = UIImageView(image: UIImage(systemName: "airplayaudio"))
        airPlayImageView.tintColor = .systemPink
        airPlayImageView.translatesAutoresizingMaskIntoConstraints = false
        return airPlayImageView
    }()
    override func viewDidLoad() {
        setupViews()
    }
    func setupViews() {
        view.addSubview(placeholderImageView)
        NSLayoutConstraint.activate([
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -125),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 250),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        view.addSubview(playingLabel)
        NSLayoutConstraint.activate([
            playingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            playingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        ])
        
        view.addSubview(controlsStackView)
        view.addSubview(playImageView)
        view.addSubview(forwardImageView)
        view.addSubview(backwardImageView)
        
        controlsStackView.addArrangedSubview(backwardImageView)
        controlsStackView.addArrangedSubview(playImageView)
        controlsStackView.addArrangedSubview(forwardImageView)
        
        NSLayoutConstraint.activate([
            controlsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 140),
            controlsStackView.widthAnchor.constraint(equalToConstant: 220),
            controlsStackView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        view.addSubview(airPlayImageView)
        NSLayoutConstraint.activate([
            airPlayImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            airPlayImageView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            airPlayImageView.widthAnchor.constraint(equalToConstant: 30),
            airPlayImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
