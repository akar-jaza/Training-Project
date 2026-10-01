import SwiftUI

struct LocationPermissionSheetView: View {
    
    @ObservedObject var viewModel: LocationPermissionViewModel
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(
                systemName: viewModel.isEnabled
                ? "location.fill"
                : "location.slash.fill"
            )
            .font(.system(size: 50))
            .foregroundStyle(
                viewModel.isEnabled
                ? .blue
                : .secondary
            )
            
            VStack(spacing: 8) {
                
                Text(
                    viewModel.isEnabled
                    ? "Location Enabled"
                    : "Location Disabled"
                )
                .font(.title2)
                .fontWeight(.semibold)
                
                Text(
                    viewModel.isEnabled
                    ? "Location Services are enabled for this app."
                    : "Location Services are currently disabled."
                )
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            }
            
            if !viewModel.isEnabled {
                
                Button {
                    viewModel.enableLocation()
                } label: {
                    
                    Text("Enable Location")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 30)
            }
            
            Spacer()
            
            Button("Done") {
                dismiss()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 10)
        }
        .padding()
        
        .onAppear {
            viewModel.refreshStatus()
        }
        
        .onChange(of: viewModel.isEnabled) { _, newValue in
            
            if newValue {
                dismiss()
            }
        }
        
        .onChange(of: scenePhase) { _, newPhase in
            
            if newPhase == .active {
                viewModel.refreshStatus()
            }
        }
    }
}
