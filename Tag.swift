import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {

}

extension Tag {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag");
    }
    
    @NSManaged public var name: String?
    @NSManaged public var entries: NSSet?
    
}

// MARK: Generated accessors for entries
extension Tag {
    
    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)
    
    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)
    
    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)
    
    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)
    
}
