import Foundation

class Deck : NSObject {
    
    static let allSpades = Value.allValues.map { (number) -> Card in
        var output = Card(color: Color.Pique,  value:number)
        return output
    }
    static let allDiamonds = Value.allValues.map { (number) -> Card in
        var output = Card(color: Color.Carreau,  value:number)
        return output
    }
    
    static let allHearts = Value.allValues.map { (number) -> Card in
        var output = Card(color: Color.Coeur,  value:number)
        return output
    }
    
    static let allClubs = Value.allValues.map { (number) -> Card in
        var output = Card(color: Color.Trefle,  value:number)
        return output
    }
    
    static let allCards = allSpades + allDiamonds + allHearts + allClubs
}

