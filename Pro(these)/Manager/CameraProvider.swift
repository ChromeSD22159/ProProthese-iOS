//
//  CameraProvider.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 05.10.23.
//

import SwiftUI
import AVFoundation

struct CameraProvider: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraProvider
        
        init(_ parent: CameraProvider) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ImageFileHandler {
    static func fileUrl(for fileName: String) -> URL {
        let dir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        return dir.appendingPathComponent(fileName)
    }
}


extension SnapshotImage {
    var data: Data? {
        guard let fileName = self.fileName else { return nil }
        
        let fileURL = ImageFileHandler.fileUrl(for: fileName)
        
        return try? Data(contentsOf: fileURL)
    }
}
