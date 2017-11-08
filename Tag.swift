import Foundation
import RealmSwift

public class Tag: Object {
    //realm must be written in objc if it requires this annotation?
    @objc dynamic var name = ""
    let entries = LinkingObjects(fromType: Entry.self, property: "tags")
}
