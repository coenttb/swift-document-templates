# Swift Document Templates

Swift Document Templates is a Swift package that enables the data-driven creation of common business documents. Designed for ease of use and automation, it leverages Swift's powerful type system and modern syntax to ensure accuracy and consistency. Whether you're generating an invoice, an agenda, or a letter, Swift Document Templates has you covered.

## Features

- **Invoice**: Generate detailed invoices with automatic calculations and custom metadata.
- **Letter**: Draft formal letters with consistent formatting and customizable content.
- **Agenda**: Create structured agendas for meetings, outlining topics, speakers, and timings. *(Under Construction)*
- **Attendance List**: Maintain a record of attendees for meetings, events, or training sessions. *(Under Construction)*
- **Invitation**: Send professional invitations for events, meetings, or conferences. *(Under Construction)*

## Installation

To install Swift Document Templates, add the following line to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-document-templates.git", from: "0.1.0")
]
```

You can then make Swift Document Templates available to your package's target by including DocumentTemplates in the dependencies of any target in your package, as follows:
```swift
targets: [
    .target(
        name: "TheNameOfYourTarget",
        dependencies: [
            .product(name: "DocumentTemplates", package: "swift-document-templates")
        ]
    )
]
```

Finally, import DocumentTemplates in your .swift file(s), as follows:
```swift
import DocumentTemplates

...your swift code...
```

## Usage

### Invoice

Generate an invoice with line items:

```swift
import DocumentTemplates

let invoice = Invoice(
    sender: .init(name: "Your Company", address: ["123 Main St", "City", "Country"], phone: "123-456-7890", email: "billing@company.com", website: "www.company.com", kvk: "12345678", btw: "NL123456789B01", iban: "NL00BANK1234567890"),
    client: .init(id: "CUST001", name: "Client Name", address: ["789 Maple St", "City", "Country"]),
    invoiceNumber: "INV001",
    invoiceDate: Date.now,
    expiryDate: (Date.now + 30.days),
    metadata: [:],
    rows: [
        .service(.init(amountOfHours: 160, hourlyRate: 140.00, vat: 21%, description: "Consulting services"))
    ]
)
```

<p align="center">
    <img src="Images/invoice.png" width="400" max-width="90%" alt="Invoice" />
</p>

### Letter

Draft a formal letter:

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
    p { "coenttb" }
}
```

<p align="center">
    <img src="Images/letter.png" width="400" max-width="90%" alt="Letter" />
</p>

## Under Construction

The following features are currently under development and will be available in future updates:

- **Agenda**: Create structured agendas for meetings, outlining topics, speakers, and timings.
- **Attendance List**: Maintain a record of attendees for meetings, events, or training sessions.
- **Invitation**: Send professional invitations for events, meetings, or conferences.

## Related projects

* [coenttb/pointfree-html](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe HTML forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [coenttb/swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [coenttb/swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [coenttb/pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [coenttb/swift-languages](https://www.github.com/coenttb/swift-languages): A cross-platform translation library written in Swift.

## Contributing

We welcome contributions to Swift Document Templates. If you find a bug or have a feature request, please open an issue on GitHub. For major changes, please open a discussion first to ensure your work aligns with the project's direction.

## License

Swift Document Templates is available under the [LICENSE](LICENSE).

## Contact

For questions or feedback, you can reach me at coen@tenthijeboonkkamp.nl.
