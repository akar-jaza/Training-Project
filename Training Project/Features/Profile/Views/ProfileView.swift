import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showAlert = false
    
    // var onLogout: () -> Void
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 244 / 255, green: 248 / 255, blue: 255 / 255),
                    .white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            .ignoresSafeArea()
            VStack(spacing: 10) {
                if viewModel.isLoading && viewModel.profile == nil {
                    ProgressView()
                } else if let userProfile = viewModel.profile {
                    VStack(spacing: 10) {
                        Text("Profile")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .tracking(1.1)
                            .padding(.bottom, 20)
                        
                        //  After creating a group, any modifier you apply to the group affects all of that group’s members.
                        Group {
                            if let uiImage = viewModel.profileImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(getImageProfile(userProfile.gender))
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(alignment: .bottom) {
                            // (Badge)
                            ZStack {
                                Circle()
                                    .fill(Color.indigo)
                                
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 38, height: 38)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .offset(y: 15)
                        }
                    }
                    .padding([.horizontal, .bottom])
                    
                    // name
                    Text(userProfile.firstName)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 1)
                    
                    // MAIL
                    Text(verbatim: userProfile.email)
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        ProfileInfo(
                            icon: "calendar",
                            value: "\(userProfile.age)",
                            title: "Age",
                            tint: .red
                        )
                        
                        ProfileInfo(
                            icon: "ruler",
                            value: "\(userProfile.height)",
                            title: "Height",
                            tint: .yellow
                        )
                        
                        ProfileInfo(
                            icon: "scalemass.fill",
                            value: "\(userProfile.weight)",
                            title: "Weight",
                            tint: .green
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 16) {
                        ProfileCards(
                            icon: "drop.fill",
                            value: userProfile.bloodGroup,
                            title: "Blood",
                            tint: .red
                        )
                        ProfileCards(
                            icon: "eye",
                            value: userProfile.eyeColor,
                            title: "Eye",
                            tint: eyeColor(userProfile.eyeColor)
                        )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.delegate?.didTapLogoutButton()
                    }, label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    })
                    .buttonStyle(.glassProminent)
                    .tint(.indigo)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                } else {
                    Text("No profile loaded")
                        .foregroundStyle(.secondary)
                }

                
            }
            .padding([.horizontal, .bottom])
        }
        
        .task {
            await viewModel.loadProfile()
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            if newValue != nil {
                showAlert = true
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                // Clear the error
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
    
    private func eyeColor(_ eyeColor: String) -> Color {
        let cleanColor = eyeColor.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch cleanColor {
        case "green":
            return .green
        case "brown":
            return .brown
        case "blue":
            return .blue
        case "gray", "grey":
            return .gray
        case "red":
            return .red
        case "hazel":
            return Color(red: 0.557, green: 0.463, blue: 0.086)
        case "amber":
            return Color(red: 1.0, green: 0.749, blue: 0.0)
        case "violet":
            return Color(red: 0.541, green: 0.169, blue: 0.886)
        default:
            return .brown
        }
    }
    
    private func getImageProfile(_ gender: String) -> String {
        let cleanGender = gender.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch cleanGender {
        case "male":
            return "male_avatar"
        case "female":
            return "female_avatar"
        default:
            return "male_avatar"
        }
    }
    
}


