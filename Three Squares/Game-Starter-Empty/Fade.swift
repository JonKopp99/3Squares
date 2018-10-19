import UIKit

/*
 Move to the next screen without an animation.
 */
class Fade: UIStoryboardSegue {
    
    override func perform() {
        self.source.navigationController?.pushViewController(self.destination, animated: false)
    }
}
