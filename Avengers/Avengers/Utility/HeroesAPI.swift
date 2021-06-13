
import Foundation

class HeroesAPI {
    static func getHeroesData() -> [Heroes]{
        let contacts = [
            Heroes(name: "Super Man", status: nil),
            Heroes(name: "Spider Man", status: nil),
            Heroes(name: "Hulk", status: nil),
  
        ]
        return contacts
    }
}
