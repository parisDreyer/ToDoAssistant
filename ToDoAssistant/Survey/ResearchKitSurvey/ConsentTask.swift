//
//  ConsentTask.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/23/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

public var ConsentTask: ORKOrderedTask {

    var steps = [ORKStep]()

    var consentDocument = ConsentDocument
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]

    let signature = consentDocument.signatures!.first as! ORKConsentSignature

    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)

    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"

    steps += [reviewConsentStep]

    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}
