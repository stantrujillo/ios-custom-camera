//
//  CameraAuthorizationHelper.swift
//  CustomCamera
//
//  Created by Stan_INT_Tech on 21/08/2025.
//

import AVFoundation
import UIKit

struct CameraAuthorizationHelper {
    static var canAccessCamera: Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)

        switch authStatus {
        case .authorized, .notDetermined:
            return cameraAvailable
        case .restricted, .denied:
            return false
        @unknown default:
            return false
        }
    }
}
