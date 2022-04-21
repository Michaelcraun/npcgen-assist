//
//  ContentView.swift
//  NPCGen Assist
//
//  Created by Michael Craun on 4/21/22.
//

import SwiftUI

import FirebaseAuth

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var isWorking: Bool = false
    
    var body: some View {
        VStack {
            if isLoggedIn {
                ZStack {
                    VStack {
                        Button {
                            isWorking = true
                            DispatchQueue.global().async {
                                FirebaseManager.compendium.updateChallengeRatings {
                                    isWorking = false
                                    print("Finished updating challenge ratings!")
                                }
                            }
                        } label: {
                            Text("Recalculate Challenge Ratings")
                        }
                    }
                    
                    if isWorking {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.7))
                            .edgesIgnoringSafeArea(.all)
                            .overlay {
                                VStack {
                                    Text("Working on it...")
                                    ProgressView()
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                }
            } else {
                Rectangle()
                    .foregroundColor(.black.opacity(0.7))
                    .edgesIgnoringSafeArea(.all)
                    .overlay {
                        VStack {
                            Text("Loading...")
                            ProgressView()
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                        }
                    }
            }
        }
        .animation(.default, value: isLoggedIn)
        .task {
            guard let credFilePath = Bundle.main.path(forResource: "firebase", ofType: "json") else {
                print("no credentials file found")
                return
            }
            
            let url = URL(fileURLWithPath: credFilePath)
            guard let data = try? Data(contentsOf: url),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String : String],
                  let email = json["username"],
                  let password = json["password"] else {
                print("unable to parse credentials file!!")
                return
            }
            
            FirebaseManager.authorization.signin(email: email, password: password) { user, error in
                guard let error = error else {
                    self.isLoggedIn = true
                    return
                }
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
