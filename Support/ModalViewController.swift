import UIKit

class ModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss view controller", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        let presentModalButton = UIButton(type: .system)
        presentModalButton.setTitle("Present view controller", for: .normal)
        presentModalButton.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [dismissButton, presentModalButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func presentViewController() {
        present(NestedModalViewController(), animated: true)
    }
}
