# SQLiteVec.swift

A fork of [SQLite.swift](https://github.com/stephencelis/SQLite.swift/tree/master) with [sqlite-vec](https://github.com/asg017/sqlite-vec) enabled.

```swift
let connection = try Connection(.inMemory)

try connection.prepare(
    """
    CREATE VIRTUAL TABLE IF NOT EXISTS embeddings USING vec0(
      id INTEGER PRIMARY KEY,
      embedding float[4]
    );
    """
).run()

let insert = try connection.prepare("""
    INSERT INTO embeddings(id, embedding)
    VALUES (?, ?)
""")
try insert.run(0, [0.0, 0.0, 1.0, 0.0])

let nearest = try connection.prepare("""
    SELECT id, distance
    FROM embeddings
    WHERE embedding MATCH ?
    ORDER BY distance
    LIMIT 20
""").run([0.0, 1.0, 0.0, 1.0])
// (0, [0.0, 0.0, 1.0, 0.0])
```

## License
Any code not covered by the existing SQLite.swift or sqlite-vec licenses is CC0 licensed.
