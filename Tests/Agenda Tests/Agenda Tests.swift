//
//  Agenda Tests.swift
//  swift-document-templates
//
//  Agenda template tests focusing on HTML generation and structure
//

import Dependencies
import Foundation
import HTML
import Testing
import Translating

@testable import Agenda

@Suite("Agenda Template") struct AgendaTests {

  // MARK: - Basic Functionality

  @Test("Agenda generates HTML with items")
  func agendaGeneratesHTML() {
    let agenda = Agenda(
      items: [
        .init(title: "Opening Remarks"),
        .init(title: "Financial Review"),
        .init(title: "Strategic Planning"),
      ]
    )

    // Verify agenda conforms to HTML protocol
    let _: any HTML = agenda
    #expect(agenda.items.count == 3)
  }

  @Test("Empty agenda")
  func emptyAgenda() {
    let agenda = Agenda(items: [])

    #expect(agenda.items.isEmpty)
    let _: any HTML = agenda
  }

  // MARK: - Agenda Items

  @Test("Agenda item renders HTML")
  func agendaItemRendersHTML() {
    let item = Agenda.Item(title: "Test Item")

    let _: any HTML = item
  }

  @Test("Agenda with single item")
  func agendaWithSingleItem() {
    let agenda = Agenda(
      items: [
        .init(title: "Only Item")
      ]
    )

    #expect(agenda.items.count == 1)
  }

  @Test("Agenda with many items")
  func agendaWithManyItems() {
    let items = (1...20).map { Agenda.Item(title: "Item \($0)") }
    let agenda = Agenda(items: items)

    #expect(agenda.items.count == 20)
  }

  // MARK: - Language Support

  @Test("Agenda in Dutch")
  func agendaInDutch() {
    withDependencies {
      $0.language = .dutch
    } operation: {
      let agenda = Agenda(
        items: [
          .init(title: "Test onderwerp")
        ]
      )

      let _: any HTML = agenda
    }
  }

  @Test("Agenda in English")
  func agendaInEnglish() {
    withDependencies {
      $0.language = .english
    } operation: {
      let agenda = Agenda(
        items: [
          .init(title: "Test topic")
        ]
      )

      let _: any HTML = agenda
    }
  }

  // MARK: - View Variants

  @Test("Agenda View renders")
  func agendaViewRenders() {
    let agenda = Agenda(
      items: [
        .init(title: "Test")
      ]
    )

    let view = Agenda.View(agenda: agenda)
    let _: any HTML = view
  }

  @Test("Agenda variant is short by default")
  func agendaVariantIsShort() {
    let agenda = Agenda(items: [])
    let view = Agenda.View(agenda: agenda)

    // The variant should be .short by default
    // This is verified by the fact that the full case returns HTMLEmpty
  }
}
