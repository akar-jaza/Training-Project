import SwiftUI

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
