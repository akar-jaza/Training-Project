import SwiftUI
import PhotosUI
import Combine

@MainActor
final class PhotosSheetViewModel: ObservableObject {

    @Published var selectedImage: UIImage? // holds the selected image

    func loadImage(from item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                return
            }

            selectedImage = image

        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
