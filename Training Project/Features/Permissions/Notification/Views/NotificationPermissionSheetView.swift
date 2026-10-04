import SwiftUI

struct NotificationPermissionSheetView: View {

    @ObservedObject var viewModel:
        NotificationPermissionViewModel

    @Environment(\.scenePhase)
    private var scenePhase

    @Environment(\.dismiss)
    private var dismiss

    @State private var didRequestPermission = false

    var body: some View {

        VStack(spacing: 24) {

            Spacer()

            Image(
                systemName: viewModel.isEnabled
                    ? "bell.fill"
                    : "bell.slash.fill"
            )
            .font(.system(size: 50))
            .foregroundStyle(
                viewModel.isEnabled
                    ? .orange
                    : .secondary
            )

            VStack(spacing: 8) {

                Text(
                    viewModel.isEnabled
                        ? "Notifications Enabled"
                        : "Notifications Disabled"
                )
                .font(.title2)
                .fontWeight(.semibold)

                Text(
                    viewModel.isEnabled
                        ? "Notifications are enabled for this app."
                        : "Notifications are currently disabled."
                )
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            }

            if !viewModel.isEnabled {

                Button {

                    didRequestPermission = true

                    Task {
                        await viewModel.enableNotifications()
                    }

                } label: {

                    Text("Enable Notifications")
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

        .task {
            await viewModel.refreshStatus()
        }

        .onChange(of: scenePhase) { _, newPhase in

            if newPhase == .active {

                Task {
                    await viewModel.refreshStatus()
                }
            }
        }

        .onChange(of: viewModel.isEnabled) { _, newValue in

            if newValue && didRequestPermission {
                dismiss()
            }
        }
    }
}
