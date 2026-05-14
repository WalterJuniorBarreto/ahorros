import SwiftUI
import Charts

struct ProyeccionData: Identifiable {
    let id = UUID()
    let mes: String
    let valor: Double
    let metodo: String
}

struct HabitsView: View {
    @AppStorage("userName") var userName: String = "Usuario"
    
    let datos: [ProyeccionData] = [
        ProyeccionData(mes: "Mes 1", valor: 100, metodo: "CASHFLOW"),
        ProyeccionData(mes: "Mes 3", valor: 300, metodo: "CASHFLOW"),
        ProyeccionData(mes: "Mes 6", valor: 650, metodo: "CASHFLOW"),
        
        ProyeccionData(mes: "Mes 1", valor: 100, metodo: "Tradicional"),
        ProyeccionData(mes: "Mes 3", valor: 150, metodo: "Tradicional"),
        ProyeccionData(mes: "Mes 6", valor: 90, metodo: "Tradicional")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ProgressView(value: 0.9)
                .progressViewStyle(LinearProgressViewStyle(tint: .black))
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            Text("\(userName), CASHFLOW crea hábitos a largo plazo")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Proyección de tu dinero")
                    .font(.headline)
                
                Chart(datos) { dato in
                    LineMark(
                        x: .value("Mes", dato.mes),
                        y: .value("Valor", dato.valor)
                    )
                    .foregroundStyle(by: .value("Método", dato.metodo))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Mes", dato.mes),
                        y: .value("Valor", dato.valor)
                    )
                    .foregroundStyle(by: .value("Método", dato.metodo))
                    .interpolationMethod(.catmullRom)
                    .opacity(0.1)
                }
                .chartForegroundStyleScale([
                    "CASHFLOW": Color.blue,
                    "Tradicional": Color.red.opacity(0.6)
                ])
                .chartYAxis(.hidden)
                .frame(height: 180)
                
                Divider()
                    .padding(.vertical, 5)
                
                HStack(spacing: 15) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                    
                    Text("El **82%** de nuestros usuarios mantienen sus ahorros en verde después de 6 meses.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(25)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 8)
            
            Spacer()
            
            NavigationLink(destination: FinancialProfileView())  {
                Text("Siguiente")
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
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
    }
}
