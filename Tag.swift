import Foundation
import RealmSwift

public class Tag: Object {
    dynamic var name = ""
    let entries = LinkingObjects(fromType: Entry.self, property: "tags")
}
