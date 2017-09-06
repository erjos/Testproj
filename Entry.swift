import Foundation
import RealmSwift

public class Entry: Object {
    dynamic var name: String?
    dynamic var notes: String?
    let tags = LinkingObjects(fromType: Tag.self, property: "entries")
}
