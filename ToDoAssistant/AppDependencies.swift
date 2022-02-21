//
//  AppDependencies.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 2/20/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

struct AppDependencies: SceneDelegate.Dependencies {
    var displayManager: DisplayManagerInput
    var categoriesDao: CategoriesDaoInput
    var categoryDictionary: CategoryDictionary
}
