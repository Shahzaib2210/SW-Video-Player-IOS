//
//  SWPlayerBrain.swift
//  SW Player
//
//  Created by Shahzaib on 1/15/22.
//  Copyright © 2022 Shahzaib. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

struct Helper
{
    func showAlert(message:String,title:String, viewController: UIViewController)
    {
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) in  print("OK...")
        }))
        viewController.present(alert, animated:true)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

