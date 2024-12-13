import XCTest
import SQLiteVec

// https://github.com/stephencelis/SQLite.swift/issues/1071
#if !os(Linux)

class CustomFunctionNoArgsTests: SQLiteTestCase {
    typealias FunctionNoOptional              = () -> SQLiteVec.Expression<String>
    typealias FunctionResultOptional          = () -> SQLiteVec.Expression<String?>

    func testFunctionNoOptional() throws {
        let _: FunctionNoOptional = try db.createFunction("test", deterministic: true) {
            "a"
        }
        let result = try db.prepare("SELECT test()").scalar() as! String
        XCTAssertEqual("a", result)
    }

    func testFunctionResultOptional() throws {
        let _: FunctionResultOptional = try db.createFunction("test", deterministic: true) {
            "a"
        }
        let result = try db.prepare("SELECT test()").scalar() as! String?
        XCTAssertEqual("a", result)
    }
}

class CustomFunctionWithOneArgTests: SQLiteTestCase {
    typealias FunctionNoOptional              = (SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String>
    typealias FunctionLeftOptional            = (SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String>
    typealias FunctionResultOptional          = (SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String?>
    typealias FunctionLeftResultOptional      = (SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String?>

    func testFunctionNoOptional() throws {
        let _: FunctionNoOptional = try db.createFunction("test", deterministic: true) { a in
            "b" + a
        }
        let result = try db.prepare("SELECT test(?)").scalar("a") as! String
        XCTAssertEqual("ba", result)
    }

    func testFunctionLeftOptional() throws {
        let _: FunctionLeftOptional = try db.createFunction("test", deterministic: true) { a in
            "b" + a!
        }
        let result = try db.prepare("SELECT test(?)").scalar("a") as! String
        XCTAssertEqual("ba", result)
    }

    func testFunctionResultOptional() throws {
        let _: FunctionResultOptional = try db.createFunction("test", deterministic: true) { a in
            "b" + a
        }
        let result = try db.prepare("SELECT test(?)").scalar("a") as! String
        XCTAssertEqual("ba", result)
    }

    func testFunctionLeftResultOptional() throws {
        let _: FunctionLeftResultOptional = try db.createFunction("test", deterministic: true) { (a: String?) -> String? in
            "b" + a!
        }
        let result = try db.prepare("SELECT test(?)").scalar("a") as! String
        XCTAssertEqual("ba", result)
    }
}

class CustomFunctionWithTwoArgsTests: SQLiteTestCase {
    typealias FunctionNoOptional              = (SQLiteVec.Expression<String>, SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String>
    typealias FunctionLeftOptional            = (SQLiteVec.Expression<String?>, SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String>
    typealias FunctionRightOptional           = (SQLiteVec.Expression<String>, SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String>
    typealias FunctionResultOptional          = (SQLiteVec.Expression<String>, SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String?>
    typealias FunctionLeftRightOptional       = (SQLiteVec.Expression<String?>, SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String>
    typealias FunctionLeftResultOptional      = (SQLiteVec.Expression<String?>, SQLiteVec.Expression<String>) -> SQLiteVec.Expression<String?>
    typealias FunctionRightResultOptional     = (SQLiteVec.Expression<String>, SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String?>
    typealias FunctionLeftRightResultOptional = (SQLiteVec.Expression<String?>, SQLiteVec.Expression<String?>) -> SQLiteVec.Expression<String?>

    func testNoOptional() throws {
        let _: FunctionNoOptional = try db.createFunction("test", deterministic: true) { a, b in
            a + b
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String
        XCTAssertEqual("ab", result)
    }

    func testLeftOptional() throws {
        let _: FunctionLeftOptional = try db.createFunction("test", deterministic: true) { a, b in
            a! + b
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String
        XCTAssertEqual("ab", result)
    }

    func testRightOptional() throws {
        let _: FunctionRightOptional = try db.createFunction("test", deterministic: true) { a, b in
            a + b!
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String
        XCTAssertEqual("ab", result)
    }

    func testResultOptional() throws {
        let _: FunctionResultOptional = try db.createFunction("test", deterministic: true) { a, b in
            a + b
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String?
        XCTAssertEqual("ab", result)
    }

    func testFunctionLeftRightOptional() throws {
        let _: FunctionLeftRightOptional = try db.createFunction("test", deterministic: true) { a, b in
            a! + b!
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String
        XCTAssertEqual("ab", result)
    }

    func testFunctionLeftResultOptional() throws {
        let _: FunctionLeftResultOptional = try db.createFunction("test", deterministic: true) { a, b in
            a! + b
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String?
        XCTAssertEqual("ab", result)
    }

    func testFunctionRightResultOptional() throws {
        let _: FunctionRightResultOptional = try db.createFunction("test", deterministic: true) { a, b in
            a + b!
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String?
        XCTAssertEqual("ab", result)
    }

    func testFunctionLeftRightResultOptional() throws {
        let _: FunctionLeftRightResultOptional = try db.createFunction("test", deterministic: true) { a, b in
            a! + b!
        }
        let result = try db.prepare("SELECT test(?, ?)").scalar("a", "b") as! String?
        XCTAssertEqual("ab", result)
    }
}

class CustomFunctionTruncation: SQLiteTestCase {
    // https://github.com/stephencelis/SQLite.swift/issues/468
    func testStringTruncation() throws {
        _ = try db.createFunction("customLower") { (value: String) in value.lowercased() }
        let result = try db.prepare("SELECT customLower(?)").scalar("TÖL-AA 12") as? String
        XCTAssertEqual("töl-aa 12", result)
    }
}

#endif
