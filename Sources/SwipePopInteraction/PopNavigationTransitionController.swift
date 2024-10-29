import UIKit

final class PopNavigationTransitionController: NSObject, UINavigationControllerDelegate {
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    let transition = PopTransition()
    weak var backupDelegate: (any UINavigationControllerDelegate)? = nil

    func begin(_ navigationController: UINavigationController) {
        backupDelegate = navigationController.delegate
        navigationController.delegate = self
        interactivePopTransition = UIPercentDrivenInteractiveTransition()
        interactivePopTransition?.completionCurve = .easeOut
        navigationController.popViewController(animated: true)
    }

    func change(_ navigationController: UINavigationController, recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translation(in: navigationController.view)
        let distance =
            translation.x > 0 ? translation.x / navigationController.view.bounds.width : 0
        interactivePopTransition?.update(distance)
    }

    func ended(_ navigationController: UINavigationController, recognizer: UIPanGestureRecognizer) {
        if recognizer.velocity(in: navigationController.view).x > 0 {
            interactivePopTransition?.finish()
        } else {
            interactivePopTransition?.cancel()
        }
        interactivePopTransition = nil
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        if operation == .pop {
            return transition
        } else {
            return nil
        }
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning
    ) -> (any UIViewControllerInteractiveTransitioning)? {
        if animationController is PopTransition {
            // ここで戻さないとnavigationTitleView(contentView)が戻らない
            navigationController.delegate = backupDelegate
            return interactivePopTransition
        } else {
            return nil
        }
    }
}
