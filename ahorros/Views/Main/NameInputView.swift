import SwiftUI

struct NameInputView: View {
    @AppStorage("userName") var userName: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ProgressView(value: 0.3)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            Text("¿Cómo te llamas?")
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 12)
            
            Text("Nos gustaría saber tu nombre para personalizar tu experiencia financiera.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            
            TextField("Escribe tu nombre", text: $userName)
                .font(.system(size: 20, weight: .medium))
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
            Spacer()
            
            NavigationLink(destination: AgeInputView()) {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(userName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.4) : Color.black)
                    .cornerRadius(25)
            }
            .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
    }
}

struct NameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NameInputView()
    }
}
