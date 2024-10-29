import UIKit

final class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var toViewController: UIViewController?

    override init() {
        super.init()
    }

    func transitionDuration(
        using transitionContext: (any UIViewControllerContextTransitioning)?
    ) -> TimeInterval {
        CATransaction.animationDuration()
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from
        )
        let toViewController = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to
        )
        guard let fromViewController, let toViewController else { return }

        transitionContext.containerView.insertSubview(
            toViewController.view,
            belowSubview: fromViewController.view
        )

        let toViewControllerXTransition = transitionContext.containerView.bounds.width * 0.3 * -1
        toViewController.view.bounds = transitionContext.containerView.bounds
        toViewController.view.center = transitionContext.containerView.center
        toViewController.view.transform = CGAffineTransform(
            translationX: toViewControllerXTransition,
            y: 0
        )

        let previousClipsToBounds = fromViewController.view.clipsToBounds
        fromViewController.view.clipsToBounds = false

        let dimmingView = UIView(frame: toViewController.view.bounds)
        let dimAmount: CGFloat = 0.1
        dimmingView.backgroundColor = UIColor(white: 0, alpha: dimAmount)
        toViewController.view.addSubview(dimmingView)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: UIView.AnimationOptions.curveLinear,
            animations: {
                toViewController.view.transform = CGAffineTransform.identity
                // workaround: CGAffineTransformを使うとdrawingGroupをつけたViewがタップ反応しなくなる
                fromViewController.view.layer.transform = CATransform3DMakeTranslation(
                    toViewController.view.frame.size.width,
                    0,
                    0
                )

                dimmingView.alpha = 0
            }
        ) { (completed) in
            dimmingView.removeFromSuperview()
            fromViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.clipsToBounds = previousClipsToBounds
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        self.toViewController = toViewController
    }

    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            toViewController?.view.transform = CGAffineTransform.identity
        }
    }
}
