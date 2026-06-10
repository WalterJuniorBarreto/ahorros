//
//  FinancialHealthCard.swift
//  ahorros
//
//  Created by Alumno Tecsup on 10/06/26.
//

import SwiftUI

enum HealthStatus {
    case excelente
    case buena
    case regular
    case riesgosa
    
    var title: String {
        switch self {
        case .excelente: return "Excelente"
        case .buena: return "Buena"
        case .regular: return "Regular"
        case .riesgosa: return "Riesgosa"
        }
    }
    
    var color: Color {
        switch self {
        case .excelente: return .mint
        case .buena: return .blue
        case .regular: return .orange
        case .riesgosa: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .excelente: return "star.fill"
        case .buena: return "hand.thumbsup.fill"
        case .regular: return "exclamationmark.triangle.fill"
        case .riesgosa: return "xmark.octagon.fill"
        }
    }
    
    var message: String {
        switch self {
        case .excelente: return "Tus finanzas están en perfecto estado."
        case .buena: return "Vas por buen camino, sigue así."
        case .regular: return "Cuidado, estás gastando casi todo lo que ingresas."
        case .riesgosa: return "Alerta: Tus gastos superan tus ingresos."
        }
    }
}

struct FinancialHealthCard: View {
    var income: Double
    var expense: Double
    
    var status: HealthStatus {
        if income == 0 && expense == 0 {
            return .buena
        } else if expense > income {
            return .riesgosa
        } else if expense >= (income * 0.8) {
            return .regular
        } else if expense >= (income * 0.5) {
            return .buena
        } else {
            return .excelente
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(status.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: status.icon)
                    .foregroundColor(status.color)
                    .font(.title2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Salud Financiera: \(status.title)")
                    .font(.headline)
                    .foregroundColor(status.color)
                Text(status.message)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(status.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
