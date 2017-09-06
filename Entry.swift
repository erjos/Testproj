import Foundation
import RealmSwift

public class Entry: Object {
    dynamic var name = ""
    dynamic var notes = ""
    let tags = List<Tag>()
}
