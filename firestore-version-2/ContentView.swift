//
//  ContentView.swift
//  firestore-version-2
//
//  Created by Sergio Olivares on 12/13/20.
//

// CRUD = Create, Read, Update and Delete

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
//
import FirebaseAuth


struct Client: Identifiable {
    
    var id = UUID()
    var clientName: String
    var clientPayment: String
   
    // using id from Firestore
    //@DocumentID var id: String? = UUID().uuidString
    // change to compactMap for the ForEach or map
    // using time from  Firestore
    @ServerTimestamp var createdAt: Timestamp?
    // using Auth for User/ data
    var userId: String?
    // Adding date and time
    var dateBook: Date
    
    
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}
struct ContentView: View {
    
    @State var clientName = ""
    @State var clientPayment = ""
    // to read data
//    @State var clientsData: [Client]
    @ObservedObject var clientsData = Clients()
    
    // to update
    @State var showSheet = false
    @State var clientId = ""
    
    // to delete
    @State var showActionSheet = false
    
    // add time
//    @State var dateBook = Date()
    
    // Firestore Auth
    let userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack {
            TextField("Add a new client", text: $clientName).padding()
            TextField("Payment", text: $clientPayment)
                .keyboardType(.numberPad).padding()
            
            ScrollView {
                Text("This will be the ScrollView")
                // showing data
                if clientsData.items.count > 0 {
                    ForEach(clientsData.items, id: \.id) { client in
                        // to Update data
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
                        }.sheet(isPresented: self.$showSheet) {
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
                                        let docRef = Firestore.firestore().document("clients/\(self.clientId)")
                                        print("setting data", self.clientId)
                                        docRef.setData(clientDataDictionary, merge: true) { (error) in
                                            if let error = error {
                                                print("error = \(error)")
                                            } else {
                                                print("data updated successfully")
                                                self.clientName = ""
                                                self.clientPayment = ""
                                                self.showSheet = false
                                              
                                                
                                            }
                                        }
                                        
                                    }, label: {
                                        Text("Update")
                                    }).padding()
                                    // end update
                                    // Delete Button
                                    Button(action: {
                                        self.showActionSheet = true
                                    }, label: {
                                        Text("Delete")
                                            .padding()
                                            .background(Color.init(red: 1, green: 0.9, blue: 0.9))
                                            .foregroundColor(.red)
                                            .cornerRadius(5)
                                    }).padding()
                                    .actionSheet(isPresented: self.$showActionSheet, content: {
                                        ActionSheet(title: Text("Delete"), message: Text("Are you sure deleting this client?"), buttons: [
                                            .default(Text("Yes"), action: {
                                                Firestore.firestore().collection("clients").document("\(self.clientId)").delete() { err in
                                                    if let err = err {
                                                        print("Error removing document: \(err)")
                                                    } else {
                                                        print("Document successfully removed client!")
                                                        self.clientName = ""
                                                        self.clientPayment = ""
                                                        self.showSheet = false
                                                    }
                                                }
                                                
                                            }),
                                            .cancel()
                                        ])
                                    })
                                    // end delete
                                }
                            }
                        }
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
            .background(Color.offWhite)
            // end showing data
            // button to add data
            Button(action: {
                let clientDataDictionary = [
                    "name": self.clientName,
                    "payment": self.clientPayment,
                    "createdAt": Date(),
                    "userId": self.userId
                ] as [String : Any]
                let docRef = Firestore.firestore().document("clients/\(UUID().uuidString)")
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
                // Data for User
                .whereField("userId", isEqualTo: self.userId)
                // order data with createdAt
                .order(by: "createdAt")
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(String(describing: error))")
                        return
                    }
                    let clients = documents.map { $0["name"]!}
                    let payments = documents.map { $0["payment"]!}
                    print(clients, self.userId)
                    // cleaning every time you add a new client
                    self.clientsData.items.removeAll()
                    //
                    
                    for i in 0..<clients.count {
                        self.clientsData.items.append(Client(id: UUID(uuidString: documents[i].documentID) ?? UUID() ,clientName: clients[i] as? String ?? "Failed to get name", clientPayment: payments[i] as? String ?? "Failed to get payment"))
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
