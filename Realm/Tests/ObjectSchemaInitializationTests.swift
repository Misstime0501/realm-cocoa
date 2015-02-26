////////////////////////////////////////////////////////////////////////////
//
// Copyright 2015 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import XCTest
import RealmSwift
import Realm.Private
import Foundation

class ObjectSchemaInitializationTests: TestCase {
    func testAllValidTypes() {
        let object = SwiftObject()
        let objectSchema = object.objectSchema

        let noSuchCol = objectSchema["noSuchCol"]
        XCTAssertNil(noSuchCol)

        let boolCol = objectSchema["boolCol"]
        XCTAssertNotNil(boolCol)
        XCTAssertEqual(boolCol!.name, "boolCol")
        XCTAssertEqual(boolCol!.type, PropertyType.Bool)
        XCTAssertFalse(boolCol!.indexed)
        XCTAssertNil(boolCol!.objectClassName)

        let intCol = objectSchema["intCol"]
        XCTAssertNotNil(intCol)
        XCTAssertEqual(intCol!.name, "intCol")
        XCTAssertEqual(intCol!.type, PropertyType.Int)
        XCTAssertFalse(intCol!.indexed)
        XCTAssertNil(intCol!.objectClassName)

        let floatCol = objectSchema["floatCol"]
        XCTAssertNotNil(floatCol)
        XCTAssertEqual(floatCol!.name, "floatCol")
        XCTAssertEqual(floatCol!.type, PropertyType.Float)
        XCTAssertFalse(floatCol!.indexed)
        XCTAssertNil(floatCol!.objectClassName)

        let doubleCol = objectSchema["doubleCol"]
        XCTAssertNotNil(doubleCol)
        XCTAssertEqual(doubleCol!.name, "doubleCol")
        XCTAssertEqual(doubleCol!.type, PropertyType.Double)
        XCTAssertFalse(doubleCol!.indexed)
        XCTAssertNil(doubleCol!.objectClassName)

        let stringCol = objectSchema["stringCol"]
        XCTAssertNotNil(stringCol)
        XCTAssertEqual(stringCol!.name, "stringCol")
        XCTAssertEqual(stringCol!.type, PropertyType.String)
        XCTAssertFalse(stringCol!.indexed)
        XCTAssertNil(stringCol!.objectClassName)

        let binaryCol = objectSchema["binaryCol"]
        XCTAssertNotNil(binaryCol)
        XCTAssertEqual(binaryCol!.name, "binaryCol")
        XCTAssertEqual(binaryCol!.type, PropertyType.Data)
        XCTAssertFalse(binaryCol!.indexed)
        XCTAssertNil(binaryCol!.objectClassName)

        let dateCol = objectSchema["dateCol"]
        XCTAssertNotNil(dateCol)
        XCTAssertEqual(dateCol!.name, "dateCol")
        XCTAssertEqual(dateCol!.type, PropertyType.Date)
        XCTAssertFalse(dateCol!.indexed)
        XCTAssertNil(dateCol!.objectClassName)

        let objectCol = objectSchema["objectCol"]
        XCTAssertNotNil(objectCol)
        XCTAssertEqual(objectCol!.name, "objectCol")
        XCTAssertEqual(objectCol!.type, PropertyType.Object)
        XCTAssertFalse(objectCol!.indexed)
        XCTAssertEqual(objectCol!.objectClassName!, "SwiftBoolObject")

        let arrayCol = objectSchema["arrayCol"]
        XCTAssertNotNil(arrayCol)
        XCTAssertEqual(arrayCol!.name, "arrayCol")
        XCTAssertEqual(arrayCol!.type, PropertyType.Array)
        XCTAssertFalse(arrayCol!.indexed)
        XCTAssertEqual(objectCol!.objectClassName!, "SwiftBoolObject")
    }

    private class SwiftFakeObject : NSObject {
        dynamic class func primaryKey() -> String! { return nil }
        dynamic class func ignoredProperties() -> [String] { return [] }
        dynamic class func indexedProperties() -> [String] { return [] }
    }

    private class SwiftObjectWithNSURL : SwiftFakeObject {
        dynamic var URL: NSURL = NSURL(string: "http://realm.io")!
    }

    private enum SwiftEnum {
        case Case1
        case Case2
    }

    private class SwiftObjectWithEnum : SwiftFakeObject {
        var swiftEnum = SwiftEnum.Case1
    }

    private class SwiftObjectWithStruct : SwiftFakeObject {
        var swiftStruct = SortDescriptor(property: "prop")
        var URL: NSURL = NSURL(string: "http://realm.io")!
    }

    private class SwiftObjectWithDatePrimaryKey : SwiftFakeObject {
        dynamic var date = NSDate()

        dynamic override class func primaryKey() -> String! {
            return "date"
        }
    }

    private class SwiftFakeObjectSubclass : SwiftFakeObject {
        dynamic var dateCol = NSDate()
    }

    func testInvalidObjects() {
        let schema = RLMObjectSchema(forObjectClass: SwiftFakeObjectSubclass.self) // Should be able to get a schema for a non-RLMObjectBase subclass
        XCTAssertEqual(schema.properties.count, 1)

        assertThrows(RLMObjectSchema(forObjectClass: SwiftObjectWithNSURL.self), "Should throw when not ignoring a property of a type we can't persist")
        RLMObjectSchema(forObjectClass: SwiftObjectWithEnum.self) // Shouldn't throw when not ignoring a property of a type we can't persist if it's not dynamic
        RLMObjectSchema(forObjectClass: SwiftObjectWithStruct.self) // Shouldn't throw when not ignoring a property of a type we can't persist if it's not dynamic
        assertThrows(RLMObjectSchema(forObjectClass: SwiftObjectWithDatePrimaryKey.self), "Should throw when setting a non int/string primary key")
    }



    func testPrimaryKey() {
        XCTAssertNil(SwiftObject().objectSchema.primaryKeyProperty, "Object should default to having no primary key property")
        XCTAssertEqual(SwiftPrimaryStringObject().objectSchema.primaryKeyProperty!.name, "stringCol")
    }

    func testIgnoredProperties() {
    }

    func testIndexedProperties() {
    }
}
