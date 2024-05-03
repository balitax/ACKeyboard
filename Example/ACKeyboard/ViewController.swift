//
//  ViewController.swift
//  ACKeyboard
//
//  Created by Agus Cahyono on 05/03/2024.
//  Copyright (c) 2024 Agus Cahyono. All rights reserved.
//

import UIKit
import ACKeyboard

class ViewController: UIViewController {
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.isEnabled = true
        button.setTitle("TRY ACKeyboard" , for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSubmitButton()
    }
    
    @objc
    func didTapButton(_ sender: UIButton) {
        let acKeyboardVC = ACKeyboardViewController()
        navigationController?.pushViewController(acKeyboardVC, animated: true)
    }
}

// MARK: Build View Components
extension ViewController {
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 48),
            submitButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
