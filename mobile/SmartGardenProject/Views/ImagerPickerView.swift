//
//  ImagerPickerView.swift
//  SmartGarden
//
//  Created by Turma01-26 on 03/04/25.
//

import SwiftUI
import UIKit

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    //var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView

        init(parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
