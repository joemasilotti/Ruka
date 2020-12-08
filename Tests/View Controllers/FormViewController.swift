import UIKit

class FormViewController: UIViewController {
    private let stackView = UIStackView()
    private let label = UILabel()

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
        let `switch` = UISwitch()
        `switch`.accessibilityLabel = "A switch"
        `switch`.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        stackView.addArrangedSubview(`switch`)

        let hiddenSwitch = UISwitch()
        hiddenSwitch.isHidden = true
        hiddenSwitch.accessibilityLabel = "A hidden switch"
        hiddenSwitch.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        stackView.addArrangedSubview(hiddenSwitch)

        let disabledSwitch = UISwitch()
        disabledSwitch.isEnabled = false
        disabledSwitch.accessibilityLabel = "A disabled switch"
        disabledSwitch.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        stackView.addArrangedSubview(disabledSwitch)

        label.text = "Disabled"
        stackView.addArrangedSubview(label)
    }

    @objc private func toggleSwitch(switch: UISwitch) {
        label.text = `switch`.isOn ? "Disabled" : "Enabled"
    }
}
