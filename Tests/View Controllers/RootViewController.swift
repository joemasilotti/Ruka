import UIKit

class RootViewController: UIViewController {
    let label = UILabel()
    var button: UIButton!
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

        button = addButton(title: "Button title")
        _ = addButton(title: "Hidden button title", isHidden: true)
        _ = addButton(title: "Disabled button title", isEnabled: false)
    }

    private func addLabel(text: String, isHidden: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.isHidden = isHidden
        stackView.addArrangedSubview(label)
        return label
    }

    private func addButton(title: String, isHidden: Bool = false, isEnabled: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        button.isHidden = isHidden
        button.isEnabled = isEnabled
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(changeLabelText), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        return button
    }

    @objc private func changeLabelText() {
        label.text = "Changed label text"
    }
}
