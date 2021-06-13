//
//  ConsentDocument.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/23/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

// Consent Document for researchkit survey
public var ConsentDocument: ORKConsentDocument {

    let consentDocument = ORKConsentDocument()
    consentDocument.title = "Example Consent"

    let consentSectionTypes: [ORKConsentSectionType] = [
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
    ]

    let consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
      let consentSection = ORKConsentSection(type: contentSectionType)
      consentSection.summary = "If you wish to complete this study..."
      consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
      return consentSection
    }

    consentDocument.sections = consentSections
    consentDocument.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))

    return consentDocument
}
