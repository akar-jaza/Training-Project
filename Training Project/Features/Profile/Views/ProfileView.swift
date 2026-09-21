import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var onLogout: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading && viewModel.user == nil {
                ProgressView()
            } else if let user = viewModel.user {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.gray)
                
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title2.bold())
                
                Text(user.email)
                    .foregroundStyle(.secondary)
            } else {
                Text("No profile loaded")
                    .foregroundStyle(.secondary)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            Spacer()
            
            Button(role: .destructive) {
                onLogout()
            } label: {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
        
        .task {
            await viewModel.loadProfile()
        }
    }
        
}
