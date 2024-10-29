import SwiftUI
import SwipePopInteraction

struct ContentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        NavigationController(rootViewController: ViewController())
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

class ViewController: UIViewController {
    let label: UILabel = UILabel()
    let button: UIButton = UIButton(configuration: .filled())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        label.text = "Hello, World!"
        button.configuration?.title = "Button"

        let stackView = UIStackView(
            arrangedSubviews: [
                label,
                button,
            ]
        )
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            view.trailingAnchor.constraint(
                equalTo: stackView.safeAreaLayoutGuide.trailingAnchor,
                constant: 20
            ),
        ])

        button.addAction(
            UIAction { [unowned self] _ in
                let vc = ViewController()
                navigationController?.pushViewController(vc, animated: true)
            },
            for: .primaryActionTriggered
        )
    }
}
