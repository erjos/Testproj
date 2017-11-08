import Foundation
import RealmSwift

public class Entry: Object {
    @objc dynamic var name = ""
    @objc dynamic var notes = ""
    let tags = List<Tag>()
}
