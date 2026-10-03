import SwiftUI
import AVKit

struct FaceIDVideoSheetView: View {

    @StateObject private var viewModel =
        FaceIDViewModel()

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

            if authenticated, let url = videoURL() {
                player = AVPlayer(url: url)
                player?.play()
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
