//  Created by dasdom on 16.12.20.
//  
//

import UIKit

class SecondTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        installStackView()
    }
    
    private func installStackView() {
        let label = UILabel()
        label.text = "Second tab"
        
        let button = UIButton(type: .system)
        button.setTitle("Present view controller from second tab", for: .normal)
        button.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func presentViewController() {
        present(ModalViewController(), animated: true)
    }
}
