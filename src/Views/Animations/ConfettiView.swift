//
//  ConfettiView.swift
//  PosturePal Pro
//
//  Confetti animation for milestone celebrations
//  Shows colorful particles falling from top of screen
//

import SwiftUI

struct ConfettiView: View {
    let colors: [Color] = [
        Color(hex: "4A90E2"),
        Color(hex: "66D9A6"),
        Color(hex: "FFB84D"),
        Color(hex: "FF6B6B"),
        Color(hex: "9B59B6")
    ]
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(color: colors[index % colors.count])
                    .offset(x: randomX(), y: animate ? 1000 : -100)
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...720) : 0))
                    .animation(
                        Animation.linear(duration: Double.random(in: 2...4))
                            .delay(Double.random(in: 0...0.5))
                            .repeatForever(autoreverses: false),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
    
    private func randomX() -> CGFloat {
        CGFloat.random(in: -200...200)
    }
}

struct ConfettiPiece: View {
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 10, height: 20)
    }
}

// MARK: - Milestone Celebration Overlay

struct MilestoneCelebrationView: View {
    let milestone: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Confetti
            ConfettiView()
                .allowsHitTesting(false)
            
            // Celebration Message
            VStack(spacing: 16) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Amazing!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(milestone) Day Streak")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("You're building a great habit!")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "4A90E2"))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                .padding(.top, 16)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.3))
                    .blur(radius: 20)
            )
            .scaleEffect(isPresented ? 1 : 0.5)
            .opacity(isPresented ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isPresented)
        }
    }
}

// MARK: - Preview

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            
            MilestoneCelebrationView(milestone: 30, isPresented: .constant(true))
        }
    }
}
