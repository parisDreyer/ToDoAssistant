//
//  SurveyTask.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/27/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

public var SurveyTask: ORKOrderedTask {

  var steps = [ORKStep]()

  //TODO: add instructions step

  //TODO: add name question

  //TODO: add 'what is your quest' question

  //TODO: add color question step

  //TODO: add summary step

  return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
