import Foundation

extension Double {
    func toString(_ decimal: Int = 6) -> String {
        let string = String(format: "%.\(decimal)f", self).replacingOccurrences(of: ".", with: ",")
        return string
    }
}

