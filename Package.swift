// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SQLiteVec.swift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .watchOS(.v4),
        .tvOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SQLiteVec",
            targets: ["SQLiteVec"]
        )
    ],
    targets: [
        .target(
            name: "SQLiteVec",
            dependencies: [
                "CSQLiteVec"
            ],
            exclude: [
                "Info.plist"
            ]
        ),
        .target(
            name: "CSQLiteVec",
            cSettings: [
                // Compile-time options
                // https://sqlite.org/compile.html#recommended_compile_time_options
                .define("SQLITE_DQS", to: "0"),
//                .define("SQLITE_THREADSAFE", to: "0"),
                .define("SQLITE_DEFAULT_MEMSTATUS", to: "0"),
                .define("SQLITE_DEFAULT_WAL_SYNCHRONOUS", to: "1"),
                .define("SQLITE_LIKE_DOESNT_MATCH_BLOBS"),
                .define("SQLITE_MAX_EXPR_DEPTH", to: "0"),
                .define("SQLITE_OMIT_DECLTYPE"),
                .define("SQLITE_OMIT_DEPRECATED"),
                .define("SQLITE_OMIT_PROGRESS_CALLBACK"),
                .define("SQLITE_OMIT_SHARED_CACHE"),
                .define("SQLITE_USE_ALLOCA"),
                .define("SQLITE_OMIT_AUTOINIT"),
                .define("SQLITE_STRICT_SUBTYPE", to: "1"),
                // Platform configuration
                // https://sqlite.org/compile.html#_platform_configuration
                .define("HAVE_ISNAN", to: "1"),
                .define("HAVE_UTIME", to: "1"),
                // Features
                // https://sqlite.org/compile.html#_options_to_enable_features_normally_turned_off
//                .define("SQLITE_ENABLE_COLUMN_METADATA"),
                .define("SQLITE_ENABLE_FTS5"),
//                .define("SQLITE_ENABLE_GEOPOLY"),
//                .define("SQLITE_ENABLE_ICU"),
                .define("SQLITE_ENABLE_MATH_FUNCTIONS"),
//                .define("SQLITE_ENABLE_PREUPDATE_HOOK"),
                .define("SQLITE_ENABLE_RTREE"),
//                .define("SQLITE_ENABLE_SESSION"),
                .define("SQLITE_ENABLE_SNAPSHOT"),
                .define("SQLITE_ENABLE_STMTVTAB"),
                .define("SQLITE_ENABLE_STAT4"),
                // For statically linking extensions
                // https://sqlite.org/loadext.html#statically_linking_a_run_time_loadable_extension
                .define("SQLITE_CORE", to: "1"),
            ]
        ),
        .testTarget(
            name: "SQLiteVecTests",
            dependencies: [
                "SQLiteVec"
            ],
            path: "Tests/SQLiteVecTests",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .copy("Resources")
            ]
        )
    ]
)
