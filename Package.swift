// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension String {
    static let agenda: Self = "Agenda"
    static let attendanceList: Self = "AttendanceList"
    static let invitation: Self = "Invitation"
    static let invoice: Self = "Invoice"
    static let letter: Self = "Letter"
    static let `internal`: Self = "Internal"
}

extension Target.Dependency {
    static var agenda: Self { .target(name: .agenda) }
    static var invitation: Self { .target(name: .invitation) }
    static var invoice: Self { .target(name: .invoice) }
    static var letter: Self { .target(name: .letter) }
    static var `internal`: Self { .target(name: .internal) }
}

extension Target.Dependency {
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var date: Self { .product(name: "Date", package: "swift-date") }
    static var languages: Self { .product(name: "Languages", package: "swift-language") }
    static var money: Self { .product(name: "Money", package: "swift-money") }
    static var percent: Self { .product(name: "Percent", package: "swift-percent") }
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlToPdf: Self { .product(name: "HtmlToPdf", package: "swift-html-to-pdf") }
}

extension [Target.Dependency] {
    static var shared: Self {
        [
            .dependencies,
            .languages,
            .html,
            .percent,
            .date,
            .money
        ]
    }
}

extension [Package.Dependency] {
    static let `default`: Self = [
        .package(url: "https://github.com/coenttb/swift-date.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-html.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-html-to-pdf.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.6"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-money.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-percent.git", branch: "main")
    ]
}

extension Package {
    static func swift_document_templates(
        targets: [(
            name: String,
            dependencies: [Target.Dependency]
        )]
    ) -> Package {

        let names = targets
            .map(\.name)
            .filter { $0 != .internal }

        return Package(
            name: "swift-document-templates",
            platforms: [.macOS(.v14), .iOS(.v17)],
            products: [
                [
                    .library(
                        name: "DocumentTemplates",
                        targets: names
                    )
                ],
                names.map { target in
                    Product.library(
                        name: "\(target)",
                        targets: ["\(target)"]
                    )
                }
            ].flatMap { $0 },
            dependencies: .default,
            targets: [
                targets.map { document in
                    Target.target(
                        name: "\(document.name)",
                        dependencies: .shared + [] + document.dependencies
                    )
                },
                targets.map { document in
                    Target.testTarget(
                        name: "\(document.name) Tests",
                        dependencies: [.init(stringLiteral: document.name)] + [.htmlToPdf]
                    )
                }
            ].flatMap { $0 }
        )
    }
}

let package = Package.swift_document_templates(
    targets: [
        (
            name: .agenda,
            dependencies: [
                .internal
            ]
        ),

        (
            name: .attendanceList,
            dependencies: [
                .internal
            ]
        ),
        (
            name: .internal,
            dependencies: [
                .htmlToPdf
            ]
        ),
        (
            name: .invitation,
            dependencies: [
                .letter,
                .internal
            ]
        ),
        (
            name: .invoice,
            dependencies: [
                .internal,
                .letter
            ]
        ),
        (
            name: .letter,
            dependencies: [
                .internal
            ]
        )
    ]
)
