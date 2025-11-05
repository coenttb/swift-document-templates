//
//  AttendanceList Tests.swift
//  swift-document-templates
//
//  Attendance List template tests focusing on HTML generation and structure
//

import Dependencies
import Foundation
import HTML
import Testing
import Translating

@testable import Attendance_List

@Suite("Attendance List Template") struct AttendanceListTests {

  // MARK: - Basic Functionality

  @Test("AttendanceList generates HTML with attendees")
  func attendanceListGeneratesHTML() {
    let list = AttendanceList(
      title: "Annual Meeting",
      metadata: [:],
      attendees: [
        .init(firstName: "John", lastName: "Doe", role: "Manager"),
        .init(firstName: "Jane", lastName: "Smith", role: "Director"),
      ]
    )

    // Verify attendance list conforms to HTML protocol
    let _: any HTML = list
    #expect(list.title == "Annual Meeting")
    #expect(list.attendees.count == 2)
  }

  @Test("AttendanceList with empty attendees")
  func attendanceListWithEmptyAttendees() {
    let list = AttendanceList(
      title: "Empty Meeting",
      metadata: [:],
      attendees: []
    )

    #expect(list.attendees.isEmpty)
    let _: any HTML = list
  }

  // MARK: - Attendee Tests

  @Test("Attendee with all fields")
  func attendeeWithAllFields() {
    let attendee = AttendanceList.Attendee(
      firstName: "John",
      lastName: "Doe",
      role: "Manager",
      signature: "John Doe Signature"
    )

    // Verify attendee can be created with all fields
    _ = attendee
  }

  @Test("Attendee without signature")
  func attendeeWithoutSignature() {
    let attendee = AttendanceList.Attendee(
      firstName: "Jane",
      lastName: "Smith",
      role: "Director"
    )

    // Verify attendee can be created without signature
    _ = attendee
  }

  // MARK: - Metadata Tests

  @Test("AttendanceList with metadata")
  func attendanceListWithMetadata() {
    let key1 = TranslatedString(dutch: "Datum", english: "Date")
    let key2 = TranslatedString(dutch: "Locatie", english: "Location")

    let list = AttendanceList(
      title: "Meeting",
      metadata: [
        key1: "2024-01-15",
        key2: "Conference Room A",
      ],
      attendees: []
    )

    #expect(list.metadata.count == 2)
    #expect(list.metadata[key1] == "2024-01-15")
    #expect(list.metadata[key2] == "Conference Room A")
  }

  @Test("AttendanceList without metadata")
  func attendanceListWithoutMetadata() {
    let list = AttendanceList(
      title: "Simple Meeting",
      attendees: []
    )

    #expect(list.metadata.isEmpty)
  }

  // MARK: - Multiple Attendees

  @Test("AttendanceList with many attendees")
  func attendanceListWithManyAttendees() {
    let attendees = (1...50).map { i in
      AttendanceList.Attendee(
        firstName: "FirstName\(i)",
        lastName: "LastName\(i)",
        role: "Role\(i)"
      )
    }

    let list = AttendanceList(
      title: "Large Meeting",
      metadata: [:],
      attendees: attendees
    )

    #expect(list.attendees.count == 50)
  }

  // MARK: - Language Support

  @Test("AttendanceList in Dutch")
  func attendanceListInDutch() {
    withDependencies {
      $0.language = .dutch
    } operation: {
      let list = AttendanceList(
        title: "Vergadering",
        metadata: [:],
        attendees: [
          .init(firstName: "Jan", lastName: "Jansen", role: "Manager")
        ]
      )

      let _: any HTML = list
    }
  }

  @Test("AttendanceList in English")
  func attendanceListInEnglish() {
    withDependencies {
      $0.language = .english
    } operation: {
      let list = AttendanceList(
        title: "Meeting",
        metadata: [:],
        attendees: [
          .init(firstName: "John", lastName: "Doe", role: "Manager")
        ]
      )

      let _: any HTML = list
    }
  }

  // MARK: - Sendable Conformance

  @Test("AttendanceList is Sendable")
  func attendanceListIsSendable() {
    let list = AttendanceList(
      title: "Test",
      metadata: [:],
      attendees: []
    )

    let _: any Sendable = list
  }

  @Test("Attendee is Sendable")
  func attendeeIsSendable() {
    let attendee = AttendanceList.Attendee(
      firstName: "Test",
      lastName: "User",
      role: "Tester"
    )

    let _: any Sendable = attendee
  }
}
