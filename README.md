# swift-document-templates

[![CI](https://github.com/coenttb/swift-document-templates/workflows/CI/badge.svg)](https://github.com/coenttb/swift-document-templates/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A Swift package for data-driven generation of common business documents including invoices, letters, agendas, attendance lists, invitations, and signature pages.

## Overview

swift-document-templates provides type-safe Swift models and HTML-based rendering for business documents. Built on swift-html's DSL, it enables programmatic document generation with multi-language support via swift-translating, and PDF export capabilities through pointfree-html-to-pdf.

## Features

- **Invoice**: Generate invoices with line items, VAT calculations, and customizable metadata
- **Letter**: Create formal business letters with structured sender/recipient information
- **Agenda**: Build meeting agendas with topics, speakers, and timings
- **Attendance List**: Track attendees for meetings, events, or training sessions
- **Invitation**: Generate professional event invitations
- **Signature Page**: Create signature blocks for natural persons, legal entities, and complex organizational structures
- **Multi-language support**: Dutch and English translations built-in via swift-translating
- **Type-safe HTML**: All documents rendered using swift-html's compile-time-checked DSL
- **PDF export**: Direct conversion to PDF via pointfree-html-to-pdf integration

## Installation

Add swift-document-templates to your package dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-document-templates.git", from: "0.1.0")
]
```

Then add the product to your target:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "DocumentTemplates", package: "swift-document-templates")
        ]
    )
]
```

## Quick Start

### Invoice Example

```swift
import DocumentTemplates
import DateExtensions
import Percent

let invoice = Invoice(
    sender: .init(
        name: "Your Company",
        address: ["123 Main St", "City", "Country"],
        phone: "123-456-7890",
        email: "billing@company.com",
        website: "www.company.com",
        kvk: "12345678",
        btw: "NL123456789B01",
        iban: "NL00BANK1234567890"
    ),
    client: .init(
        id: "CUST001",
        name: "Client Name",
        address: ["789 Maple St", "City", "Country"]
    ),
    invoiceNumber: "INV001",
    invoiceDate: Date.now,
    expiryDate: (Date.now + 30.days),
    metadata: [:],
    rows: [
        .service(.init(
            amountOfHours: 160,
            hourlyRate: 140.00,
            vat: 21%,
            description: "Consulting services"
        ))
    ]
)
```

<p align="center">
    <img src="Images/invoice.png" width="400" max-width="90%" alt="Invoice" />
</p>

### Letter Example

```swift
import DocumentTemplates

let sender: Letter.Sender = .init(
    name: "Your Company",
    address: ["123 Main St", "City", "Country"],
    phone: "123-456-7890",
    email: "info@company.com",
    website: "www.company.com"
)

let recipient: Letter.Recipient = .init(
    name: "Recipient Name",
    address: ["456 Elm St", "City", "Country"]
)

let letter = Letter(
    sender: sender,
    recipient: recipient,
    location: "Utrecht",
    date: (sending: Date.now, signature: nil),
    subject: "Subject of the Letter"
) {
    "Dear \(recipient.name),"
    p { "I hope this finds you well." }
    p { "Best regards," }
    p { "Your Name" }
}
```

<p align="center">
    <img src="Images/letter.png" width="400" max-width="90%" alt="Letter" />
</p>

## Usage Examples

### Agenda

Create meeting agendas with topics:

```swift
import Agenda

let agenda = Agenda(
    items: [
        .init(title: "Opening Remarks"),
        .init(title: "Q1 Financial Results"),
        .init(title: "Strategic Planning Discussion")
    ]
)
```

### Attendance List

Track event participants:

```swift
import AttendanceList

let attendanceList = AttendanceList(
    title: "Annual Conference",
    metadata: [:],
    attendees: [
        .init(firstName: "John", lastName: "Doe", role: "Manager"),
        .init(firstName: "Jane", lastName: "Smith", role: "Director")
    ]
)
```

### Invitation

Generate event invitations:

```swift
import Invitation

let invitation = Invitation(
    sender: .init(
        name: "Your Company",
        address: ["123 Main St", "City"],
        phone: "123-456-7890",
        email: "events@company.com",
        website: "www.company.com"
    ),
    recipient: .init(
        id: "RECIP001",
        name: "Guest Name",
        address: ["456 Guest St", "City"]
    ),
    invitationNumber: "INV-2024-001",
    invitationDate: Date.now,
    eventDate: Date.now,
    location: "Conference Center",
    metadata: [:]
)
```

### Signature Page

Create signature blocks with Signatory enum:

```swift
import SignaturePage

// Single individual
let individual = Signatory.individual(
    name: "John Doe",
    title: .init(dutch: "Directeur", english: "Director"),
    metadata: [:]
)

// Group of signers
let group = Signatory(
    name: .init(dutch: "Bedrijf B.V.", english: "Company B.V."),
    signers: [
        .init(name: .init("Jane Smith"), metadata: [:]),
        .init(name: .init("Bob Johnson"), metadata: [:])
    ],
    metadata: [:]
)
```

## Platform Support

- macOS 14.0+
- iOS 17.0+
- Mac Catalyst 17.0+

## Related Packages

- [coenttb/pointfree-html](https://github.com/coenttb/pointfree-html): A Swift DSL for type-safe HTML forked from [pointfreeco/swift-html](https://github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
- [coenttb/swift-html](https://github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://github.com/coenttb/swift-css) and [pointfree-html](https://github.com/coenttb/pointfree-html).
- [coenttb/swift-html-to-pdf](https://github.com/coenttb/swift-html-to-pdf): Convert HTML to PDF on iOS and macOS with concurrent WebKit rendering.
- [coenttb/pointfree-html-to-pdf](https://github.com/coenttb/pointfree-html-to-pdf): A library for converting HTML to PDFs using WebKit.
- [coenttb/swift-translating](https://github.com/coenttb/swift-translating): Multi-language support for Swift applications.
- [coenttb/swift-percent](https://github.com/coenttb/swift-percent): Type-safe percentage calculations in Swift.
- [coenttb/swift-money](https://github.com/coenttb/swift-money): Type-safe monetary value handling.

## License

This package is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome. Please open an issue to discuss significant changes before submitting a pull request.

## Contact

For questions or feedback, reach out at coen@tenthijeboonkkamp.nl or visit [coenttb.com](https://coenttb.com).
