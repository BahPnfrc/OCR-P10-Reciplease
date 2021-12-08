import Foundation
import CoreData

extension RecipeFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeFavorite> {
        return NSFetchRequest<RecipeFavorite>(entityName: "RecipeFavorite")
    }

    @NSManaged public var image: String?
    @NSManaged public var ingredientLines: [String]?
    @NSManaged public var label: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var totalTime: Int64
    @NSManaged public var url: String?
    @NSManaged public var yield: Int64

}

extension RecipeFavorite : Identifiable {}
