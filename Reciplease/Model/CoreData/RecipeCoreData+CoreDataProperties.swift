import Foundation
import CoreData

extension RecipeCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCoreData> {
        return NSFetchRequest<RecipeCoreData>(entityName: "RecipeCoreData")
    }

    @NSManaged public var image: String?
    @NSManaged public var ingredientLines: [String]?
    @NSManaged public var label: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var totalTime: Int32
    @NSManaged public var url: String?
    @NSManaged public var yield: Int32

}

extension RecipeCoreData : Identifiable {

}
