//
//  FileLoader.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 7/3/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

final class FileLoader {
    static func readDataFrom(fileName: String) -> Data?
      {
          var data: Data?
          if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
              do {
                  let fileUrl = URL(fileURLWithPath: path)
                  data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
              } catch {
                // TODO: add error handling
                return nil
              }
          }
          return data
      }
}
