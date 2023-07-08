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
import FirebaseFirestore

struct VideoRecorder: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    @Binding var isShown: Bool
    @Binding var videoURL: URL?
    var questionID: String
    var userID: String
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera // Set sourceType first
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera), mediaTypes.contains("public.movie") {
                picker.mediaTypes = ["public.movie"] // Then set mediaTypes
                picker.allowsEditing = true
                picker.videoQuality = .typeHigh
                picker.cameraCaptureMode = .video // Finally, set cameraCaptureMode
            }
        }
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, questionID: questionID, userID: userID)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoRecorder
        var questionID: String
        var userID: String
        
        init(_ parent: VideoRecorder, questionID: String, userID: String) {
            self.parent = parent
            self.questionID = questionID
            self.userID = userID
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.videoURL = url
                parent.isShown = false
                parent.uploadVideo(withURL: url, questionID: questionID, userID: userID)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }

    func uploadVideo(withURL url: URL, questionID: String, userID: String) {
        print("uploadVideo called")
        // Reference to Google Cloud Storage
        let storage = Storage.storage(url: "gs://soulprint-402c8.appspot.com")
        let storageRef = storage.reference()
        let uuidString = UUID().uuidString
        let videoRef = storageRef.child("videos/\(uuidString).mov")

        let uploadTask = videoRef.putFile(from: url, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading file: \(error)")
                return
            }
            
            guard let _ = metadata else {
                // Handle unsuccessful upload
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            videoRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    return
                }
                guard let downloadURL = url else {
                    // Handle any errors
                    return
                }
                
                // Here you can handle the download URL
                // Save the downloadURL along with the question's ID to Firestore
                let db = Firestore.firestore()
                db.collection("questions").addDocument(data: [
                    "questionID": questionID,
                    "userID": userID,
                    "videoID": uuidString,
                    "videoURL": downloadURL.absoluteString
                ]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
    }
}



