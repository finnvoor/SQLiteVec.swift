import XCTest
import Foundation
@testable import SQLiteVec
import CSQLiteVec

class ConnectionAttachTests: SQLiteTestCase {
    func test_attach_detach_memory_database() throws {
        let schemaName = "test"

        try db.attach(.inMemory, as: schemaName)

        let table = Table("attached_users", database: schemaName)
        let name = SQLiteVec.Expression<String>("string")

        // create a table, insert some data
        try db.run(table.create { builder in
            builder.column(name)
        })
        _ = try db.run(table.insert(name <- "test"))

        // query data
        let rows = try db.prepare(table.select(name)).map { $0[name] }
        XCTAssertEqual(["test"], rows)

        try db.detach(schemaName)
    }

    func test_attach_detach_file_database() throws {
        let schemaName = "test"
        let testDb = fixture("test", withExtension: "sqlite")

        try db.attach(.uri(testDb, parameters: [.mode(.readOnly)]), as: schemaName)

        let table = Table("tests", database: schemaName)
        let email = SQLiteVec.Expression<String>("email")

        let rows = try db.prepare(table.select(email)).map { $0[email] }
        XCTAssertEqual(["foo@bar.com"], rows)

        try db.detach(schemaName)
    }

    func test_detach_invalid_schema_name_errors_with_no_such_database() throws {
        XCTAssertThrowsError(try db.detach("no-exist")) { error in
            if case let Result.error(message, code, _) = error {
                XCTAssertEqual(code, SQLITE_ERROR)
                XCTAssertEqual("no such database: no-exist", message)
            } else {
                XCTFail("unexpected error: \(error)")
            }
        }
    }
}