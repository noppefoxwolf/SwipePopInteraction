# SwipePopInteraction

> Deprecated on iOS 26 and later because UIKit supports swipe-back by default.

```swift
import UIKit
import SwipePopInteraction

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let interaction = SwipePopInteraction(delegate: self)
        view.addInteraction(interaction)
    }
}
 
extension NavigationController: SwipePopInteractionDelegate {
    func navigationController(for interaction: SwipePopInteraction) -> UINavigationController {
        self
    }
}
```
