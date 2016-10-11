//
//  CameraViewController.swift
//  CustomCamera
//
//  Created by Stan Trujillo on 23/10/17.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    let captureSession = AVCaptureSession()
    let capturePhotoOutout = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?

    lazy var overlay: CameraOverlayView = {
        let view = CameraOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.captureButtonTapped = { [weak self] in
            self?.saveToCamera()
        }
        return view
    }()

    lazy var deniedLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera access denied!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()

        if CameraAuthorizationHelper.canAccessCamera {

            configureVideoCapture()

            self.view.addSubview(overlay)
            overlay.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            overlay.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            overlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            view.addSubview(deniedLabel)
            deniedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            deniedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            deniedLabel.isHidden = false
        }
    }

    private func configureBackButton() {

        guard let navView = UIHostingController(rootView: NavigateBackView(onTap: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })).view else { assertionFailure(); return }

        navView.backgroundColor = .clear
        navView.bounds = CGRect(x: 0, y: 0, width: 44, height: 44)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navView)
    }

    private func configureVideoCapture() {

        guard let device = AVCaptureDevice.default(
            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
            for: AVMediaType.video,
            position: .back) else { return }

        capturePhotoOutout.isHighResolutionCaptureEnabled = true
        captureSession.sessionPreset = AVCaptureSession.Preset.photo

        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: device))

            if captureSession.canAddOutput(capturePhotoOutout) {
                captureSession.addOutput(capturePhotoOutout)
            }
        } catch {
            // handle permission error?
            print("error: \(error.localizedDescription)")
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        previewLayer.videoGravity = .resizeAspectFill

        Task.detached {
            await self.captureSession.startRunning()
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {

        if let error = error {
            print(error.localizedDescription)
        }

        if let buffer = photoSampleBuffer,
            let preview = previewPhotoSampleBuffer,
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: preview) {
            if let image = UIImage(data: data) {
                overlay.add(image)
            }
        }
    }

    func saveToCamera() {
        let settings = AVCapturePhotoSettings()

        settings.isHighResolutionPhotoEnabled = true

        // The preview is not used in this example, but it isn't clear how to suppress it...
        settings.previewPhotoFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: settings.availablePreviewPhotoPixelFormatTypes.first!,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]

        self.capturePhotoOutout.capturePhoto(with: settings, delegate: self)
    }
}
