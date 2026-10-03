import SwiftUI
import AVKit

struct FaceIDVideoSheetView: View {
    
    @StateObject private var viewModel =
    FaceIDViewModel()
    
    // weird, but it fixes the glitch when for the first time the sheet is showing up and the video graphics are not showing up and only the audio works in the background.
    @State private var sheetLoaded: Int = 0
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var player: AVPlayer?
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            if viewModel.isAuthenticated {
                
                videoView
                
            } else {
                
                authenticationView
            }
        }
        .padding()
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in
            
            if authenticated ,let url = videoURL() {
                player = AVPlayer(url: url)
                
                switch sheetLoaded {
                case 0 :
                    Task {
                        try? await Task.sleep(for: .seconds(1))
                        player?.play()
                    }
                    
                default:
                    player?.play()
                }
            }
        }
        .task {
            switch sheetLoaded {
            case 0, 1:
                sheetLoaded += 1
            default:
                break
            }
        }
    }
    
    private var authenticationView: some View {
        
        VStack(spacing: 30) {
            
            Spacer()
            
            Image(systemName: "faceid")
                .font(.system(size: 55))
                .foregroundStyle(.indigo)
            
            Button {
                
                Task {
                    await viewModel.authenticate()
                }
                
            } label: {
                
                Text("Authenticate to meet your new girlfriend 😭")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            Spacer()
            
            Button("Done") {
                dismiss()
            }
            .foregroundStyle(.secondary)
        }
    }
    
    
    private var videoView: some View {
        
        VStack {
            
            if let player = player {
                
                VideoPlayer(player: player)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                
            } else {
                Text("Video not found.")
                    .foregroundStyle(.secondary)
            }
            
            Button("Done") {
                dismiss()
            }
            .padding(.top)
        }
    }
    
    private func videoURL() -> URL? {
        
        guard let asset = NSDataAsset(
            name: "Tap to meet your new girlfriend"
        ) else {
            return nil
        }
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Tap to meet your new girlfriend.mp4")
        
        if !FileManager.default.fileExists(atPath: tempURL.path) {
            try? asset.data.write(to: tempURL)
        }
        
        return tempURL
    }
}

#Preview {
    FaceIDVideoSheetView()
}
