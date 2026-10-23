import SwiftUI

struct RewardPopupView: View {
    let xp: Int
    let gems: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                
                Text("Quest Completed!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 20) {
                    VStack {
                        Text("+\(xp)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        Text("XP Gained")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider().frame(height: 30)
                    
                    VStack {
                        Text("+\(gems)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        Text("Gems Earned")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Awesome!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
    }
}
