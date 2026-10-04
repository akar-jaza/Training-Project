import SwiftUI
import PhotosUI

// https://youtu.be/hB8MTEJj3CA?si=9j2mTJR8OWoWRvhR

struct PhotosSheetView: View {
    @State
    private var selectedItem: PhotosPickerItem? // holds the selected photo item
    
    @StateObject
    private var viewModel = PhotosSheetViewModel()
    
    var body: some View {
        VStack {
            // display the selected image or the placeholder
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(25)
            } else {
                Text("No Image Selected")
                    .foregroundStyle(.gray)
                    .padding()
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images, // show only images
                photoLibrary: .shared()
            ) {
                Text("Select Photo")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .foregroundStyle(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
            }
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else { return }
                
                Task {
                    await viewModel.loadImage(from: newItem)
                }
                
            }
        }
        .padding()
    }
}


#Preview {
    PhotosSheetView()
}
