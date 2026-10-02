import SwiftUI

struct CameraPermissionSheetView: View {

    @ObservedObject var viewModel:
        CameraPermissionViewModel

    @Environment(\.scenePhase)
    private var scenePhase

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {

        Group {

            if viewModel.isEnabled {

                cameraPreview

            } else {

                permissionView
            }
        }
        .onAppear {

            viewModel.refreshStatus()

            if viewModel.isEnabled {
                viewModel.startCamera()
            }
        }
        .onDisappear {
            viewModel.stopCamera()
        }
        .onChange(of: scenePhase) { _, newPhase in

            if newPhase == .active {

                viewModel.refreshStatus()

                if viewModel.isEnabled {
                    viewModel.startCamera()
                }
            }
        }
    }

    private var permissionView: some View {

        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "camera.fill")
                .font(.system(size: 50))
                .foregroundStyle(.purple)

            VStack(spacing: 8) {

                Text("Camera Access")

                    .font(.title2)
                    .fontWeight(.semibold)

                Text(
                    "Allow this app to access your camera."
                )
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            }

            Button {

                Task {
                    await viewModel.enableCamera()
                }

            } label: {

                Text("Enable Camera")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 30)

            Spacer()

            Button("Done") {
                dismiss()
            }
            .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var cameraPreview: some View {

        ZStack {
            CameraPreviewView(
                session: viewModel.captureSession
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .padding()

            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.toggleCameraPosition()
                    } label: {
                        Image(systemName: "arrow.trianglehead")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
        
        
    }
}
