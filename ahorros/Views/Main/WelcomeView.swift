import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 50)
                
                Image("logo-ahorros")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                HStack(spacing: 20) {
                    InfoCardView(icon: "shield.fill", iconColor: .red, title: "Seguridad")
                    InfoCardView(icon: "chart.line.uptrend.xyaxis", iconColor: .blue, title: "Ahorro")
                }
                .padding(.top, 30)
                
                Spacer()
                
                Text("¡Bienvenido a tu Gestor!")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.bottom, 8)
                
                Text("Organiza tus ingresos y gastos diarios de la forma más rápida y sencilla.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                NavigationLink(destination: NameInputView()) {
                    Text("Siguiente")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.black)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InfoCardView: View {
    var icon: String
    var iconColor: Color
    var title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 20))
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
