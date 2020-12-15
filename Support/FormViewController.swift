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
        addSwitch(accessibilityLabel: "A switch")
        addSwitch(accessibilityLabel: "A hidden switch", isHidden: true)
        addSwitch(accessibilityLabel: "A disabled switch", isEnabled: false)

        let offScreenSwitch = UISwitch()
        offScreenSwitch.accessibilityLabel = "An off screen switch"
        offScreenSwitch.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        view.addSubview(offScreenSwitch)
        offScreenSwitch.frame.origin.y = -100

        switchlabel.text = "Disabled"
        stackView.addArrangedSubview(switchlabel)
    }

    private func addSteppers() {
        addStepper(accessibilityLabel: "A stepper")
        addStepper(accessibilityLabel: "A hidden stepper", isHidden: true)
        addStepper(accessibilityLabel: "A disabled stepper", isEnabled: false)

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
        addSlider(accessibilityLabel: "A slider")
        addSlider(accessibilityLabel: "A hidden slider", isHidden: true)
        addSlider(accessibilityLabel: "A disabled slider", isEnabled: false)

        let offScreenSlider = UISlider()
        offScreenSlider.value = 2
        offScreenSlider.maximumValue = 4
        offScreenSlider.accessibilityLabel = "An off screen slider"
        offScreenSlider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        view.addSubview(offScreenSlider)
        offScreenSlider.frame.origin.y = -100

        sliderLabel.text = "2.0"
        stackView.addArrangedSubview(sliderLabel)
    }

    private func addTextFields() {
        addTextField(placeholder: "Text field placeholder")
        addTextField(placeholder: "Hidden text field placeholder", isHidden: true)
        addTextField(placeholder: "Disabled text field placeholder", isEnabled: false)

        let offScreenTextField = UITextField()
        offScreenTextField.placeholder = "Off screen text field placeholder"
        offScreenTextField.delegate = self
        view.addSubview(offScreenTextField)
        offScreenTextField.frame.origin.y = -100

        stackView.addArrangedSubview(textFieldLabel)
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

    private func addSlider(accessibilityLabel: String, isHidden: Bool = false, isEnabled: Bool = true) {
        let slider = UISlider()
        slider.value = 2
        slider.maximumValue = 4
        slider.isHidden = isHidden
        slider.isEnabled = isEnabled
        slider.accessibilityLabel = accessibilityLabel
        slider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
        stackView.addArrangedSubview(slider)
    }

    private func addTextField(placeholder: String, isHidden: Bool = false, isEnabled: Bool = true) {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.isHidden = isHidden
        textField.isEnabled = isEnabled
        textField.delegate = self
        stackView.addArrangedSubview(textField)
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
