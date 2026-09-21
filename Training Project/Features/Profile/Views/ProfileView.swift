import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var onLogout: () -> Void
    
    var body: some View {
        
        VStack(spacing: 20) {
            if viewModel.isLoading && viewModel.user == nil {
                ProgressView()
            } else if let user = viewModel.user {
                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .tracking(1.1)
                        .padding(.bottom, 20)
                    
                    Image("avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(alignment: .bottom) {
                            // Lower Action Circle (Badge)
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
                .padding()
                
                // name
                Text("Akar")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                
                // MAIL
                Text(verbatim: "akar.jaza1212@gmail.com")
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 10)
                
                HStack(spacing: 20) {
                    ProfileInfo(
                        icon: "calendar",
                        value: "20",
                        title: "Age",
                        tint: .red
                    )
                    
                    ProfileInfo(
                        icon: "ruler",
                        value: "178",
                        title: "Height",
                        tint: .yellow
                    )
                    
                    ProfileInfo(
                        icon: "scalemass.fill",
                        value: "70",
                        title: "Weight",
                        tint: .green
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                HStack(spacing: 16) {
                    ProfileCards(icon: "drop.fill", value: "-O", title: "Blood", tint: .red)
                    ProfileCards(
                        icon: "eye",
                        value: "Green",
                        title: "Eye",
                        tint: .green
                    )
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {}, label: {
                    Text("Log Out")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                })
                .buttonStyle(.glassProminent)
                .tint(.indigo)
                .padding(.horizontal)
                
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .frame(width: 80, height: 80)
//                    .foregroundStyle(.gray)
//                
//                Text("\(user.firstName) \(user.lastName)")
//                    .font(.title2.bold())
//                
//                Text(user.email)
//                    .foregroundStyle(.secondary)
            } else {
                Text("No profile loaded")
                    .foregroundStyle(.secondary)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            
//            Button(role: .destructive) {
//                onLogout()
//            } label: {
//                Text("Log Out")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.red)
        }
        .padding()
        
        .task {
            await viewModel.loadProfile()
        }
    }
        
}


struct ProfileInfo: View {
    let icon: String
    let value: String
    let title: String
    let tint: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 55, height: 55)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProfileCards: View {
    let icon: String
    let value: String
    let title: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(tint)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.gray.opacity(0.08))
        )
    }
}
