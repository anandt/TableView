
import Foundation

struct DetailsViewModel {
    
    func fetchStatus(star: Float?) -> Rating? {
        let selectedValue: Rating?
        switch star {
        case 1.0:
            selectedValue = .Normal
        case 2.0:
            selectedValue = .VeryGood
        case 3.0:
            selectedValue = .Awesome
        default:
            selectedValue = .Normal
        }
        return selectedValue
    }
}
