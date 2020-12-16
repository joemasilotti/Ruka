import UIKit

class FormViewController: UIViewController {
    private let stackView = UIStackView()
    private let switchlabel = UILabel()
    private let stepperLabel = UILabel()
    private let sliderLabel = UILabel()
    private let textFieldLabel = UILabel()

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
        addSwitches()
        addSteppers()
        addSliders()
        addTextFields()
    }

    private func addSwitches() {
        _ = addSwitch(accessibilityLabel: "A switch")
        _ = addSwitch(accessibilityLabel: "A hidden switch", isHidden: true)
        _ = addSwitch(accessibilityLabel: "A disabled switch", isEnabled: false)

        let a11yLabeledSwitch = addSwitch(accessibilityLabel: "")
        a11yLabeledSwitch.accessibilityIdentifier = "a11y labeled switch"

        let a11yIdentifiedSwitch = addSwitch(accessibilityLabel: "")
        a11yIdentifiedSwitch.accessibilityIdentifier = "a11y identified switch"

        let offScreenSwitch = UISwitch()
        offScreenSwitch.accessibilityLabel = "An off screen switch"
        offScreenSwitch.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        view.addSubview(offScreenSwitch)
        offScreenSwitch.frame.origin.y = -100

        switchlabel.text = "Disabled"
        stackView.addArrangedSubview(switchlabel)
    }

    private func addSteppers() {
        _ = addStepper(accessibilityLabel: "A stepper")
        _ = addStepper(accessibilityLabel: "A hidden stepper", isHidden: true)
        _ = addStepper(accessibilityLabel: "A disabled stepper", isEnabled: false)

        let a11yLabeledStepper = addStepper(accessibilityLabel: "")
        a11yLabeledStepper.accessibilityLabel = "a11y labeled stepper"

        let a11yIdentifiedStepper = addStepper(accessibilityLabel: "")
        a11yIdentifiedStepper.accessibilityIdentifier = "a11y identified stepper"

        let offScreenStepper = UIStepper()
        offScreenStepper.accessibilityLabel = "An off screen stepper"
        offScreenStepper.value = 2
        offScreenStepper.addTarget(self, action: #selector(changeStepper), for: .valueChanged)
        view.addSubview(offScreenStepper)
        offScreenStepper.frame.origin.y = -100

        stepperLabel.text = "2.0"
        stackView.addArrangedSubview(stepperLabel)
    }

    private func addSliders() {
        _ = addSlider(accessibilityLabel: "A slider")
        _ = addSlider(accessibilityLabel: "A hidden slider", isHidden: true)
        _ = addSlider(accessibilityLabel: "A disabled slider", isEnabled: false)

        let a11yLabeledSlider = addSlider(accessibilityLabel: "")
        a11yLabeledSlider.accessibilityLabel = "a11y labeled slider"

        let a11yIdentifiedSlider = addSlider(accessibilityLabel: "")
        a11yIdentifiedSlider.accessibilityIdentifier = "a11y identified slider"

        let offScreenSlider = UISlider()
        offScreenSlider.value = 2
        offScreenSlider.maximumValue = 4
        offScreenSlider.accessibilityLabel = "An off screen slider"
        offScreenSlider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        view.addSubview(offScreenSlider)
        offScreenSlider.frame.origin.y = -100

        sliderLabel.text = "20.0"
        stackView.addArrangedSubview(sliderLabel)
    }

    private func addTextFields() {
        _ = addTextField(placeholder: "Text field placeholder")
        _ = addTextField(placeholder: "Hidden text field placeholder", isHidden: true)
        _ = addTextField(placeholder: "Disabled text field placeholder", isEnabled: false)

        let a11yLabeledTextField = addTextField(placeholder: "")
        a11yLabeledTextField.accessibilityLabel = "a11y labeled text field"

        let a11yIdentifiedTextField = addTextField(placeholder: "")
        a11yIdentifiedTextField.accessibilityIdentifier = "a11y identified text field"

        let offScreenTextField = UITextField()
        offScreenTextField.placeholder = "Off screen text field placeholder"
        offScreenTextField.delegate = self
        view.addSubview(offScreenTextField)
        offScreenTextField.frame.origin.y = -100

        stackView.addArrangedSubview(textFieldLabel)
    }

    private func addSwitch(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) -> UISwitch {
        let `switch` = UISwitch()
        `switch`.isHidden = isHidden
        `switch`.isEnabled = isEnabled
        `switch`.accessibilityLabel = accessibilityLabel
        `switch`.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        stackView.addArrangedSubview(`switch`)
        return `switch`
    }

    private func addStepper(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) -> UIStepper {
        let stepper = UIStepper()
        stepper.value = 2
        stepper.isHidden = isHidden
        stepper.isEnabled = isEnabled
        stepper.accessibilityLabel = accessibilityLabel
        stepper.addTarget(self, action: #selector(changeStepper), for: .valueChanged)
        stackView.addArrangedSubview(stepper)
        return stepper
    }

    private func addSlider(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) -> UISlider {
        let slider = UISlider()
        slider.value = 20
        slider.maximumValue = 40
        slider.isHidden = isHidden
        slider.isEnabled = isEnabled
        slider.accessibilityLabel = accessibilityLabel
        slider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        stackView.addArrangedSubview(slider)
        return slider
    }

    private func addTextField(placeholder: String, isHidden: Bool = false, isEnabled: Bool = true) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.isHidden = isHidden
        textField.isEnabled = isEnabled
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        return textField
    }

    @objc private func toggleSwitch(switch: UISwitch) {
        switchlabel.text = `switch`.isOn ? "Disabled" : "Enabled"
    }

    @objc private func changeStepper(stepper: UIStepper) {
        stepperLabel.text = "\(stepper.value)"
    }

    @objc private func changeSlider(slider: UISlider) {
        sliderLabel.text = "\(slider.value)"
    }
}

extension FormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldLabel.text = textField.text
        return true
    }
}
