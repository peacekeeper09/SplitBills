import SwiftUI

struct ContentView: View {
    @State private var totalCost = ""
    @State private var people = 4
    @State private var tipIndex = 2
    @State private var customTip = ""
    let tipPercentages = [0, 5, 10, 15]
    @AppStorage("isDarkMode") private var isDarkMode = false 
  
    var customTipIndex: Int {
        tipPercentages.count - 1
    }
    
    var splitAmount: Double {
        let tipPercentage = customTip.isEmpty ? Double(tipPercentages[tipIndex]) : Double(customTip) ?? 0
        let orderTotal = Double(totalCost) ?? 0
        let finalAmount = ((orderTotal / 100 * tipPercentage) + orderTotal)
        return finalAmount / Double(people)
    }
    
    func reset() {
        totalCost = ""
        tipIndex = 2
        customTip = ""
        people = 4
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter an amount").font(.headline)) {
                    TextField("Amount", text: $totalCost)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Select a tip amount (%)").font(.headline)) {
                    Picker("Tip percentage", selection: $tipIndex) {
                        ForEach(tipPercentages.indices, id: \.self) { index in
                            if index != customTipIndex {
                                Text("\(tipPercentages[index])%")
                            } else {
                                Text("Custom")
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if tipIndex == customTipIndex {
                        TextField("Custom Tip", text: $customTip)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("How many people?").font(.headline)) {
                    Slider(value: Binding<Double>(
                        get: { Double(people) },
                        set: { people = Int($0) }
                    ), in: 1...25, step: 1)
                    Text("\(Int(people)) people")
                        .font(.headline)
                }
                
                Section(header: Text("Total Amount").font(.headline)) {
                    HStack {
                        Spacer()
                        Text("$\(splitAmount, specifier: "%.2f")")
                            .font(.system(size: 40, weight: .bold, design: .default))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
                
                Button(action: reset) {
                    Text("Reset")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding(.vertical)
            }
            .navigationTitle("Split The Bills")
            .preferredColorScheme(isDarkMode ? .dark : .light) 
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
