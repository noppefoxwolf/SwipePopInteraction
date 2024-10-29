public import UIKit

@MainActor
public protocol SwipePopInteractionDelegate: AnyObject {
    func navigationController(for interaction: SwipePopInteraction) -> UINavigationController
}

@MainActor
public final class SwipePopInteraction: NSObject, UIInteraction {
    let panGestureRecognizer = UIPanGestureRecognizer()
    let transitionController = PopNavigationTransitionController()
    weak var delegate: SwipePopInteractionDelegate? = nil

    public init(delegate: SwipePopInteractionDelegate) {
        self.delegate = delegate
    }

    public weak var view: UIView? = nil

    public func willMove(to view: UIView?) {
        self.view = view
    }

    public func didMove(to view: UIView?) {
        panGestureRecognizer.addTarget(self, action: #selector(onPan))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.delaysTouchesBegan = true
        view?.addGestureRecognizer(panGestureRecognizer)
    }

    @objc
    func onPan(gesture: UIPanGestureRecognizer) {
        guard let navigationController = delegate?.navigationController(for: self) else { return }
        switch gesture.state {
        case .began:
            transitionController.begin(navigationController)
        case .changed:
            transitionController.change(navigationController, recognizer: panGestureRecognizer)
        case .ended, .cancelled, .failed:
            transitionController.ended(navigationController, recognizer: panGestureRecognizer)
        default:
            break
        }
    }
}

extension SwipePopInteraction: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = delegate?.navigationController(for: self) else {
            return false
        }
        guard navigationController.viewControllers.count > 1 else { return false }
        let isAnimated = navigationController.transitionCoordinator?.isAnimated ?? false
        guard !isAnimated else { return false }

        if panGestureRecognizer == gestureRecognizer,
            let panGesture = gestureRecognizer as? UIPanGestureRecognizer
        {
            let velocity = panGesture.velocity(in: view)
            return velocity.x > abs(velocity.y)
        }

        return true
    }
}
