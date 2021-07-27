//
//  ContentView.swift
//  NewTimeApp
//
//  Created by Gilbert Solano on 7/9/21.
//
import SwiftUICharts
import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var taskStore = TaskStore()
    @State var newToDo : String = ""
    
    @State var selectedIndex = 0
    @State var text: String = ""
    @State private var isLoading = false
    
    @State var selectedHours: Int = 0
    @State var selectedMinutes: Int = 0
    
    let icons = ["house", "plus", "gear"]
    
    var searchBar : some View {
        HStack {
            TextField("Enter a new task...", text: self.$newToDo)
            Button( action: self.addNewToDo, label: {
                Text("Add New")
            })
        }
    }
    
    func addNewToDo () {
        taskStore.tasks.append(Task(id:
                                        String(taskStore.tasks.count + 1), toDoItem: newToDo))
        self.newToDo = ""
    }
    
    /*func delete(at offsets : IndexSet) {
        taskStore.task.remove(atOffsets: offsets)
    }
    */
    var body: some View {
        
        VStack {
            //Content
            ZStack {
                switch selectedIndex{
                case 0:
                    //Home View
                    NavigationView{
                        
                        VStack{
                            
                            List {
                                Section(header: Text("Completed Tasks")) {
                                    ForEach(self.taskStore.tasks) { task in
                                    Text(task.toDoItem)
                                        .font(.headline)
                                    Text("Session Duration: \(selectedHours) : \(selectedMinutes)")
                                    }.onMove(perform: self.move)
                                     .onDelete(perform: self.delete)
                                }
                                Section(header: Text("Overview")){
                                    PieChartView(data: [1, 2, 3],
                                                 title: "Daily Summary")
                                }
                            }.navigationBarItems(trailing: EditButton())
                        }
                            
                        .navigationTitle("Home")
                    
                    }
                    //Add Tasks View
                case 1:
                    NavigationView{
                        VStack{
                            
                            searchBar.padding()
                            Divider()
                            
                // Wheel Pickers
                            HStack {
                                Picker("", selection: $selectedHours){
                                    ForEach(0..<24, id: \.self) { i in
                                        Text("\(i) hours").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 100).clipped()
                            
                                Picker("", selection: $selectedMinutes){
                                    ForEach(0..<60, id: \.self) { i in
                                        Text("\(i) min").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(width: 100).clipped()
                                
                            }.padding(.horizontal)
                            
                            //Session Duration
                            Text("Session Duration: \(selectedHours) hours and \(selectedMinutes) minutes")
                        }.navigationTitle("Add Tasks")
                    }
                default:
                    //Overview
                    NavigationView{
                        VStack{
                            //Bar Chart
                           /* BarChartView(
                                data: ChartData(values: [
                                    ("hello", 10),
                                    ("goodbye", 7)
                                ]), title: "Bar Chart"
                            )*/
                            Spacer()
                            
                            PieChartView(data: [],
                                         title: "Daily Summary")
                            Spacer()
                            
                           // LineChartView(data: [3,2],
                            //              title: "Productivity Rate")
                            Spacer()
                        }.navigationTitle("Overview")
                    }
                }
            }//Zstack
            
            
            Spacer()
            HStack{
                ForEach(0..<3, id: \.self) {number in
                    Spacer()
                    Button(action: {
                        self.selectedIndex = number
                    }, label: {
                        if number == 1 {
                            Image(systemName: icons[number])
                                .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .cornerRadius(30)
                        }
                        else {
                            Image(systemName: icons[number])
                                .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default))
                                .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                        }
                    })
                    Spacer()
                }
            }
        }
    }
    
    func move(from source: IndexSet, to destination : Int) {
        taskStore.tasks.move(fromOffsets: source, toOffset: destination )
    }
    
    func delete(at offsets : IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
    
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

