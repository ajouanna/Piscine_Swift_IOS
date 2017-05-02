import Foundation // pour NSObject
import Darwin // pour arc4random_uniform

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


extension Array {
    
     mutating func shuffle() {
        var indexArray = Array<Int>(indices) // indices est un e propriete de mon Array
        var index = indexArray.endIndex // dernier element de l'index
        
        let indexIterator = AnyIterator<Int> { // la closure ci-dessous est appelee pour chaque element
            guard let nextIndex = indexArray.index(index, offsetBy: -1, limitedBy: indexArray.startIndex)
                else { return nil }
            
            index = nextIndex
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            if randomIndex != index {
                swap(&indexArray[randomIndex], &indexArray[index]) // le & permet un passage par reference
            }
            
            return indexArray[index]
        }
        
        self = indexIterator.map { self[$0] }
    }
    
}
