import SwiftUI

struct ShopView: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Gems Wallet Header Bar
                    HStack {
                        Label("Your Gems Balance:", systemImage: "gem.fill")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(viewModel.profile.gems) Gems")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Inventory Shop List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.profile.inventory) { item in
                                HStack(spacing: 14) {
                                    Image(systemName: item.iconName)
                                        .font(.system(size: 28))
                                        .foregroundColor(.purple)
                                        .frame(width: 50, height: 50)
                                        .background(Color.purple.opacity(0.1))
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        let success = viewModel.purchaseReward(item: item)
                                        if success {
                                            alertMessage = "Successfully redeemed \(item.name)!"
                                        } else {
                                            alertMessage = "Not enough gems to unlock this reward!"
                                        }
                                        showAlert = true
                                    }) {
                                        Text(item.isPurchased ? "Unlocked" : "\(item.gemCost) 💎")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(item.isPurchased ? Color.green.opacity(0.2) : Color.cyan)
                                            .foregroundColor(item.isPurchased ? .green : .white)
                                            .cornerRadius(8)
                                    }
                                    .disabled(item.isPurchased)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Reward Shop")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Shop"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
