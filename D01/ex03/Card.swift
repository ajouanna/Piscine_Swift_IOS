import Foundation

class Card : NSObject {
    
    var value : Value
    var color : Color

    init(color: Color, value: Value) {
        self.color = color
        self.value = value
    }
    
    override var description : String {
        var str = String(describing: self.value)
        str += " de " + self.color.rawValue
        return str
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let castObject = object as? Card {
            return (self.value == castObject.value) && (self.color == castObject.color)
        }
        return false
    }
}
