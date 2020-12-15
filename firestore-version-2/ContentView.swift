//
//  ContentView.swift
//  firestore-version-2
//
//  Created by Sergio Olivares on 12/13/20.
//

// CRUD = Create, Read, Update and Delete

import SwiftUI
import Firebase

struct Client: Identifiable {
    var id = UUID()
    var clientName: String
    var clientPayment: String
}

struct ContentView: View {
    
    @State var clientName = ""
    @State var clientPayment = ""
    // to read data
    @State var clientsData: [Client]
    
    // to update
    @State var showSheet = false
    @State var clientId = ""
    
    var body: some View {
        VStack {
            TextField("Add a new client", text: $clientName).padding()
            TextField("Payment", text: $clientPayment)
                .keyboardType(.numberPad).padding()
            
            ScrollView {
                Text("This will be the ScrollView")
                // showing data
                if clientsData.count > 0 {
                    ForEach(clientsData, id: \.id) { client in
                        // Update
                        Button(action: {
                            self.clientId = client.id.uuidString
                            self.clientName = client.clientName
                            self.clientPayment = client.clientPayment
                            self.showSheet = true
                        
                        }) {
                            HStack {
                                Text("\(client.clientName) || \(client.clientPayment)")
                                    .frame(maxWidth: UIScreen.main.bounds.size.width)
                                    .foregroundColor(.white)
                            }.background(Color.blue)
                        }.sheet(isPresented: self.$showSheet, content: {
                            VStack {
                                Text("Modify client - \(self.clientId)")
                                TextField("Add a new client", text: $clientName).padding()
                                TextField("Payment", text: $clientPayment)
                                    .keyboardType(.numberPad).padding()
                                HStack {
                                    Button(action: {
                                        // will put update here
                                        let clientDataDictionary = [
                                         "name": self.clientName,
                                         "payment": self.clientPayment
                                        ]
                                        let docRef = Firestore.firestore().document("clients/\(client.id)")
                                         print("setting data")
                                         docRef.setData(clientDataDictionary, merge: true) { (error) in
                                             if let error = error {
                                                 print("error = \(error)")
                                             } else {
                                                 print("data updated successfully")
                                                self.showSheet = false
                                                 self.clientName = ""
                                                 self.clientPayment = ""
                                              
                                             }
                                         }
                                   
                                    }, label: {
                                        Text("Update")
                                    }).padding()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        Text("Delete")
                                    }).padding()
                                }
                            }
                        })
                        //
//                        HStack {
//                            Text("\(client.clientName) || \(client.clientPayment)")
//                                .frame(maxWidth: UIScreen.main.bounds.size.width)
//                        }.background(Color.blue)
                      
                    }
                } else {
                    Text("Submit a client")
                }
                
            }.frame(width: UIScreen.main.bounds.size.width)
            .background(Color.red)
            // end showing data
            // button to add data
            Button(action: {
               let clientDataDictionary = [
                "name": self.clientName,
                "payment": self.clientPayment
               ]
                let docRef = Firestore.firestore().document("clients/\(self.clientId)")
                print("setting data")
                docRef.setData(clientDataDictionary) { (error) in
                    if let error = error {
                        print("error = \(error)")
                    } else {
                        print("data uploaded successfully")
                        self.clientName = ""
                        self.clientPayment = ""
                     
                    }
                }
            }, label: {
                Text("Add Client")
            })
           
        }
        // To read data
        .onAppear() {
            Firestore.firestore().collection("clients")
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error)")
                        return
                    }
                    let clients = documents.map { $0["name"]!}
                    let payments = documents.map { $0["payment"]!}
                    print(clients)
                    // cleaning every time you add a new client
                    self.clientsData.removeAll()
                    //
                    
                    for i in 0..<clients.count {
                        self.clientsData.append(Client(id: UUID(uuidString: documents[i].documentID) ?? UUID() ,clientName: clients[i] as? String ?? "Failed to get name", clientPayment: payments[i] as? String ?? "Failed to get payment"))
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(clientsData: [])
    }
}
