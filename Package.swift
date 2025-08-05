// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension String {
    static let agenda: Self = "Agenda"
    static let attendanceList: Self = "Attendance List"
    static let signaturePage: Self = "Signature Page"
    static let invitation: Self = "Invitation"
    static let invoice: Self = "Invoice"
    static let letter: Self = "Letter"
    static let documentUtilities: Self = "Document Utilities"
}

extension Target.Dependency {
    static var agenda: Self { .target(name: .agenda) }
    static var invitation: Self { .target(name: .invitation) }
    static var invoice: Self { .target(name: .invoice) }
    static var letter: Self { .target(name: .letter) }
    static var signaturePage: Self { .target(name: .signaturePage) }
    static var documentUtilities: Self { .target(name: .documentUtilities) }
}

extension Target.Dependency {
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var typesFoundation: Self { .product(name: "TypesFoundation", package: "swift-types-foundation") }
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
    static var translations: Self { .product(name: "Translations", package: "swift-translating") }
    static var money: Self { .product(name: "Money", package: "swift-money") }
    static var percent: Self { .product(name: "Percent", package: "swift-percent") }
    static var html: Self { .product(name: "HTML", package: "swift-html") }
    static var htmlToPdf: Self { .product(name: "PointFreeHTMLToPDF", package: "pointfree-html-to-pdf") }
    static var htmlLanguages: Self { .product(name: "PointFreeHTMLTranslating", package: "pointfree-html-translating") }
    static var collections: Self { .product(name: "Collections", package: "swift-collections") }
}

extension [Target.Dependency] {
    static var shared: Self {
        [
            .dependencies,
            .translating,
            .html,
            .htmlLanguages,
            .percent,
            .typesFoundation,
            .money
        ]
    }
}

extension [Package.Dependency] {
    static let `default`: Self = [
        .package(url: "https://github.com/apple/swift-collections.git", branch: "main"),
        .package(url: "https://github.com/coenttb/pointfree-html-to-pdf.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/pointfree-html-translating.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-types-foundation.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-html.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-html-to-pdf.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-translating.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-money.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-percent.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.6")
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

        return Package(
            name: "swift-document-templates",
            platforms: [
                .macOS(.v14),
                .iOS(.v17),
                .macCatalyst(.v17)
            ],
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
                .documentUtilities
            ]
        ),

        (
            name: .attendanceList,
            dependencies: [
                .documentUtilities
            ]
        ),
        (
            name: .invitation,
            dependencies: [
                .letter,
                .documentUtilities
            ]
        ),
        (
            name: .invoice,
            dependencies: [
                .letter,
                .documentUtilities
            ]
        ),
        (
            name: .letter,
            dependencies: [
                .documentUtilities
            ]
        ),
        (
            name: .signaturePage,
            dependencies: [
                .collections,
                .documentUtilities
            ]
        ),
        (
            name: .documentUtilities,
            dependencies: [
                .translating,
                .translations
            ]
        )
    ]
)
