import UIKit

class RootViewController: UIViewController {
    private let label = UILabel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        installStackView()
        installSubviews()
    }

    private func installStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
    }

    private func installSubviews() {
        label.text = "Label text"
        stackView.addArrangedSubview(label)
        _ = addLabel(text: "Hidden label text", isHidden: true)

        _ = addButton(title: "Button title")
        _ = addButton(title: "Hidden button title", isHidden: true)
        _ = addButton(title: "Disabled button title", isEnabled: false)

        _ = addButton(title: "Push view controller", action: #selector(pushViewController))
        _ = addButton(title: "Pop view controller", action: #selector(popViewController))
        _ = addButton(title: "Present view controller", action: #selector(presentViewController))
        _ = addButton(title: "Dismiss view controller", action: #selector(dismissViewController))

        _ = addButton(title: "Show alert", action: #selector(showAlert))
    }

    private func addLabel(text: String, isHidden: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.isHidden = isHidden
        stackView.addArrangedSubview(label)
        return label
    }

    private func addButton(title: String, isHidden: Bool = false, isEnabled: Bool = true, action: Selector = #selector(changeLabelText)) -> UIButton {
        let button = UIButton(type: .system)
        button.isHidden = isHidden
        button.isEnabled = isEnabled
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
        return button
    }

    @objc private func changeLabelText() {
        label.text = "Changed label text"
    }

    @objc private func pushViewController() {
        navigationController?.pushViewController(RootViewController(), animated: true)
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func presentViewController() {
        present(RootViewController(), animated: true)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }

    @objc private func showAlert() {
        let alert = UIAlertController(title: "Alert title", message: "Alert message.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
            self?.label.text = "Changed label text"
        }))
        present(alert, animated: true)
    }
}
