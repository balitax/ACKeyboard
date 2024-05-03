//
//  ACKeyboardViewController.swift
//  ACKeyboard_Example
//
//  Created by Agus Cahyono on 03/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import ACKeyboard

class ACKeyboardViewController: UIViewController {
    
    deinit {
        print("Deinit #\(self)")
    }
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.isEnabled = true
        button.setTitle("Submit Password" , for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = false
        scrollView.delaysContentTouches = false
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImage(named: "forgot")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please input your password"
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.placeholder = "Please input your password"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()

    private let acKeyboard = ACKeyboard()
    private var submitButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        acKeyboard.stop()
    }

    private func commonInit() {
        view.backgroundColor = .white
        
        setupSubmitButtonConstraint()
        setupView()
    }
    
    private func keyboardHandler() {
        acKeyboard
            .on(event: .willShow) { [weak self] option in
                self?.submitButtonLayoutIfNeeded(by: option.endKeyboardFrame.height.supportSafeArea)
            }
            .on(event: .willHide) { [weak self] option in
                self?.resetLayoutSubmitButton()
            }
            .start()
    }
}

// MARK: UITextFieldDelegate
extension ACKeyboardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Build View Components
extension ACKeyboardViewController {
    private func setupSubmitButtonConstraint() {
        view.addSubview(submitButton)
        
        if UIDevice().hasNotch {
            submitButtonConstraint = submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            submitButtonConstraint = submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        }
        
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 48),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            submitButtonConstraint
        ])
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: submitButton.topAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)
        ])
        
        stackView.addArrangedSubview(buildLogoView())
        stackView.addArrangedSubview(buildLabelView())
        stackView.addArrangedSubview(buildTextField())
    }
    
    private func buildLogoView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 89),
            
            view.heightAnchor.constraint(equalToConstant: logoImageView.frame.height),
        ])
        
        return view
    }
    
    private func buildLabelView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    private func buildTextField() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: view.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        return view
    }
    
    func submitButtonLayoutIfNeeded(by value: CGFloat) {
        submitButtonConstraint.constant = (-value - 16)  // add padding 16
        view.layoutIfNeeded()
    }
    
    private func resetLayoutSubmitButton() {
        submitButtonConstraint.constant = -16
        view.layoutIfNeeded()
    }
}

internal extension UIApplication {
    var currentActiveWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        }
        
        return UIApplication.shared.keyWindow
    }
}

internal extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.currentActiveWindow?.safeAreaInsets.bottom ?? 0 > 0
            return bottom
        }
        
        return false
    }
}
