//
//  ContentView.swift
//  TyemteeGuess
//
//  Created by Viettasc on 2/12/20.
//  Copyright © 2020 Viettasc. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["tyemtee1", "tyemtee2", "tyemtee3", "tyemtee4", "tyemtee5", "tyemtee6"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...5)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    // animation
    @State private var amount = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @State private var opacity = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    
    func tap(_ number: Int) -> Void {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        showingScore = true
        // animation
        if scoreTitle == "Correct" {
            score += 1
            amount[number] += 360
        } else {
            opacity[number] -= 0.25
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.6), Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .font(.title)
                        .foregroundColor(.pink)
                    Text("tyemtee" + "\(correctAnswer)")
                        .foregroundColor(.pink)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach(0...5, id: \.self) { number in
                    Button(action: {
                        print("number: \(number)")
                        withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                            self.tap(number)
                        }
                        
                    }) {
                        FlagImage(name: self.countries[number])
                    }
                    // animation
                    .rotation3DEffect(.degrees(self.amount[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.opacity[number])
                }
                Text("Current score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreTitle == "Correct" ? "Your score is \(score)" : "The correct answer is \(correctAnswer)"), dismissButton: .default(Text("Continue"), action: {
                self.question()
            }))
        }
        .onAppear {
            print("correctAnswer: \(self.correctAnswer)")
        }
    }
    
    func question() -> Void {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...5)
        print("correctAnswer: ", correctAnswer)
        opacity = [1, 1, 1, 1, 1, 1]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
