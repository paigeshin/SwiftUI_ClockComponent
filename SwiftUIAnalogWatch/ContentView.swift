//
//  ContentView.swift
//  SwiftUIAnalogWatch
//
//  Created by paige on 2021/11/06.
//

import SwiftUI

struct ContentView: View {
    
    @State var isDark = false
    
    var body: some View {
        NavigationView {
            Home(isDark: $isDark)
                .navigationBarHidden(true)
                .preferredColorScheme(isDark ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @Binding var isDark: Bool
    var width = UIScreen.main.bounds.width
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Analog Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer(minLength: 0)
                
                Button {
                    isDark.toggle()
                } label: {
                    Image(systemName: isDark ? "sun.min.fill" : "mon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(.primary)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer(minLength: 0)
            
            //MARK: - DRAWING LOGIC
            ZStack {
                Circle()
                    .fill(Color("Color").opacity(0.1))
                
                // Seconds And Min Dots
                
                ForEach(0..<60, id: \.self) { i in
                    Rectangle()
                        .fill(.primary)
                        .frame(width: 2, height: (i % 5) == 0 ? 15: 5)
                        // 60 / 25 = 5
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                }
                
                // Sec...
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: 2, height: (width - 180) / 2)
                    .offset(y: -(width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
                
                // Min
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: 4, height: (width - 200) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
                
                // Hour
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: 4.5, height: (width - 240) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour + currentTime.min / 60) * 30))
                
                // Center Circle...
                
                Circle()
                    .fill(.primary)
                    .frame(width: 15, height: 15)
                
            }
            .frame(width: width - 80, height: width - 80)
            
            // getting Locale Region Name...
//            Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//                .padding(.top, 35)
        
            //MARK: - TIME DISPLAY
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding(.top, 10)
            
             Spacer()
            
        }
        //MARK: - TIMER LOGIC
        .onAppear {
            let calendar = Calendar.current
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            withAnimation(Animation.linear(duration: 0.01)) {
                self.currentTime = Time(min: min, sec: sec, hour: hour)
            }
        }
        .onReceive(receiver) { (_) in
            let calendar = Calendar.current
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            withAnimation(Animation.linear(duration: 0.01)) {
                self.currentTime = Time(min: min, sec: sec, hour: hour)
            }
        }
        
    }
    
    func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        return format.string(from: Date())
    }
    
}

// Calculating time...
struct Time {
    var min: Int
    var sec: Int
    var hour: Int
}
