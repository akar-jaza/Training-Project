import SwiftUI

struct ProfileInfo: View {
    let icon: String
    let value: String
    let title: LocalizedStringKey
    let unit: String?
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
            
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(unit ?? "")
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
