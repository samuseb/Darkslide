import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    private enum Constants {
        static let defaultCompressionQuality = 0.3
    }
    @Binding var imageData: Data?
    var enableCropping = false
    var compressionQuality: Double?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = enableCropping
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePicker: self)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let imagePicker: ImagePicker
        let compressionQuality: Double

        init(imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
            self.compressionQuality = imagePicker.compressionQuality ?? Constants.defaultCompressionQuality
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.editedImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: compressionQuality) else {
                    return
                }
                imagePicker.imageData = data
            } else if let image = info[.originalImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: compressionQuality) else {
                    return
                }
                imagePicker.imageData = data
            }
            picker.dismiss(animated: true)
        }
    }
}
