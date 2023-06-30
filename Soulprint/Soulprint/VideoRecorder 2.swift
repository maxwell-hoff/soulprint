//
//  VideoRecorder.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI
import UIKit
import AVKit
import AVFoundation
import FirebaseStorage

struct VideoRecorder: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    @Binding var isShown: Bool
    @Binding var videoURL: URL?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = true
        picker.videoQuality = .typeHigh
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoRecorder
        init(_ parent: VideoRecorder) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
                parent.isShown = false
                parent.uploadVideo(withURL: url)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }

    func uploadVideo(withURL url: URL) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let videoRef = storageRef.child("videos/\(UUID().uuidString).mov")

        let uploadTask = videoRef.putFile(from: url, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Handle unsuccessful upload
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            videoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Handle any errors
                    return
                }
                // Here you can handle the download URL
            }
        }
    }
}

