import UIKit

class FormViewController: UIViewController {
    private let stackView = UIStackView()
    private let switchlabel = UILabel()
    private let stepperLabel = UILabel()

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
        addSwitch(accessibilityLabel: "A switch")
        addSwitch(accessibilityLabel: "A hidden switch", isHidden: true)
        addSwitch(accessibilityLabel: "A disabled switch", isEnabled: false)

        switchlabel.text = "Disabled"
        stackView.addArrangedSubview(switchlabel)

        addStepper(accessibilityLabel: "A stepper")
        addStepper(accessibilityLabel: "A hidden stepper", isHidden: true)
        addStepper(accessibilityLabel: "A disabled stepper", isEnabled: false)

        stepperLabel.text = "2.0"
        stackView.addArrangedSubview(stepperLabel)
    }

    private func addSwitch(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) {
        let `switch` = UISwitch()
        `switch`.isHidden = isHidden
        `switch`.isEnabled = isEnabled
        `switch`.accessibilityLabel = accessibilityLabel
        `switch`.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        stackView.addArrangedSubview(`switch`)
    }

    private func addStepper(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.isHidden = isHidden
        stepper.isEnabled = isEnabled
        stepper.accessibilityLabel = accessibilityLabel
        stepper.addTarget(self, action: #selector(changeStepper), for: .valueChanged)
        stackView.addArrangedSubview(stepper)
    }

    @objc private func toggleSwitch(switch: UISwitch) {
        switchlabel.text = `switch`.isOn ? "Disabled" : "Enabled"
    }

    @objc private func changeStepper(stepper: UIStepper) {
        stepperLabel.text = "\(stepper.value)"
    }
}
