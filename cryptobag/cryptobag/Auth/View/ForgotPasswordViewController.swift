import UIKit
protocol ForgotPasswordView: AnyObject {
    func showInvalidEmailAlert()
    func showPasswordResetSent()
    func showErrorSendingPasswordReset(with error: Error)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordView {
    
    private let headView = AuthView(title: "Forgot Password", subTitle: "Reset your password")
    private let email = CustomTextField(fieldType: .email)
    private let resetPasswordButton = CustomButton(title: "Reset Password", hasBackground: true, fontSize: .big)
    
    private var presenter: ForgotPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ForgotPasswordPresenter(view: self)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headView)
        view.addSubview(email)
        view.addSubview(resetPasswordButton)
        
        headView.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            headView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headView.heightAnchor.constraint(equalToConstant: 230),
            
            email.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: 11),
            email.centerXAnchor.constraint(equalTo: headView.centerXAnchor),
            email.heightAnchor.constraint(equalToConstant: 55),
            email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            resetPasswordButton.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            resetPasswordButton.centerXAnchor.constraint(equalTo: headView.centerXAnchor),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
        
        resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    @objc private func didTapForgotPassword() {
        let email = self.email.text ?? ""
        
        presenter.resetPassword(with: email)
    }
    
    // MARK: - ForgotPasswordView methods
    
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showPasswordResetSent() {
        AlertManager.showPasswordResetSent(on: self)
    }
    
    func showErrorSendingPasswordReset(with error: Error) {
        AlertManager.showErrorSendingPasswordReset(on: self, with: error)
    }
}


