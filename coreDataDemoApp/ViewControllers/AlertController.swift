//
//  AlertController.swift
//  coreDataDemoApp
//
//  Created by Никита Микрюков on 03.10.2020.
//  Copyright © 2020 Никита Микрюков. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    func alert(task: Task?, delivery: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newTaskValue = self.textFields?.first?.text else { return }
            delivery(newTaskValue)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField()
    }
}
