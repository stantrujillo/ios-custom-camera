//
//  CameraOverlayView.swift
//  CustomCamera
//
//  Created by Stan Trujillo on 20/08/2025.
//

import UIKit
import SwiftUI

class SelectedImageCollection: ObservableObject {
    @Published var images: [UIImage] = []
}

class CameraOverlayView: UIView {

    var captureButtonTapped: (() -> Void)?

    let maxImagesToShow = 5
    let capturedImages = SelectedImageCollection()

    lazy var shutterButtonView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(resource: .cameraButton)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCaptureButtonTapped)))
        return view
    }()

    lazy var nextButtonView: UIView = {
        let vc = UIHostingController(rootView: NavigateDoneView(onTap: {
            print("--- next")
        }))
        guard let view = vc.view else { assertionFailure(); return UIView() }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    lazy var imageGalleryHostingController: UIHostingController<ImageHistoryView> = {
        let hostingController = UIHostingController(rootView: ImageHistoryView(collection: capturedImages))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        return hostingController
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear

        addSubview(shutterButtonView)
        shutterButtonView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        shutterButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50.0).isActive = true
        shutterButtonView.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        shutterButtonView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true

        addSubview(nextButtonView)
        nextButtonView.isHidden = true
        nextButtonView.rightAnchor.constraint(equalTo: rightAnchor, constant: -60.0).isActive = true
        nextButtonView.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
        nextButtonView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        nextButtonView.centerYAnchor.constraint(equalTo: shutterButtonView.centerYAnchor).isActive = true

        addSubview(imageGalleryHostingController.view)
        imageGalleryHostingController.view.rightAnchor.constraint(equalTo: rightAnchor, constant: 6.0).isActive = true
        imageGalleryHostingController.view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageGalleryHostingController.view.widthAnchor.constraint(equalToConstant: 88.0).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleCaptureButtonTapped() {
        captureButtonTapped?()
    }

    func showCameraButton(_ visible: Bool) {
        shutterButtonView.isHidden = !visible
    }

    func add(_ image: UIImage) {
        capturedImages.images.append(image)
        shutterButtonView.isHidden = capturedImages.images.count >= maxImagesToShow
        nextButtonView.isHidden = capturedImages.images.count < 1
    }
}
