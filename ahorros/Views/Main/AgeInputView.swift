import SwiftUI

struct AgeInputView: View {
    @AppStorage("userAge") var age: Int = 21

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ProgressView(value: 0.6)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            Text("¿Cuántos años tienes?")
                .font(.system(size: 34, weight: .bold))
                .padding(.bottom, 12)
            
            Text("Tu edad nos ayuda a adaptar las metas y recomendaciones financieras especialmente para ti.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 60)
            
            VStack {
                HStack(spacing: 30) {
                    Button(action: {
                        if age > 14 { age -= 1 }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 65, height: 65)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(spacing: 2) {
                        Text("\(age)")
                            .font(.system(size: 85, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        Text("AÑOS")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.gray)
                            .tracking(2)
                    }
                    .frame(width: 130)
                    
                    Button(action: {
                        if age < 100 { age += 1 }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 65, height: 65)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            NavigationLink(destination: HabitsView())  {
                Text("Continuar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.black)
                    .cornerRadius(25)
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 30)
        .navigationBarHidden(true)
    }
}

struct AgeInputView_Previews: PreviewProvider {
    static var previews: some View {
        AgeInputView()
    }
}
