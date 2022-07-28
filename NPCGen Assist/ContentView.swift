//
//  ContentView.swift
//  NPCGen Assist
//
//  Created by Michael Craun on 4/21/22.
//

import SwiftUI

import FirebaseAuth
import Rulebook

struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var isWorking: Bool = false
    
    var body: some View {
        VStack {
            if isLoggedIn {
                ZStack {
                    VStack {
                        Button { updateChallengeRatings() } label: { Text("Recalculate Challenge Ratings") }
                        Button { convertToFirestore() } label: { Text("Convert to Firestore") }
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
    
    private func convertToFirestore() {
        // This one is going to be a monumentous task...
        // 1. Convert all RTD data to the Rulebook equivalents
        let rulebookActions = Compendium.instance.actions.map({ Rulebook.Action(action: $0) })
        let rulebookArmors = Compendium.instance.armors.map({ Rulebook.Armor(armor: $0) })
        let rulebookTraits = Compendium.instance.traits.map({ Rulebook.Trait(trait: $0) })
        let rulebookWeapons = Compendium.instance.weapons.map({ Rulebook.Action(action: $0) })
        var rulebookOccupations = Compendium.instance.occupations.map({ Rulebook.Occupation(occupation: $0) })
        let rulebookRaces = Compendium.instance.races.map({ Rulebook.Race(race: $0) })
        let rulebookSubraces = Compendium.instance.subraces.map({ Rulebook.Subrace(subrace: $0) })
        
        // 2. Actions, Armor, Weapons, and Traits now have different id's, so we now need to
        // reassociate these objects with all other data types
        for occupation in rulebookOccupations {
            
        }
        
        for race in rulebookRaces {
            
        }
        
        for subrace in rulebookSubraces {
            
        }
        
        // 3. Upload all data to Firestore
        
    }
    
    private func updateChallengeRatings() {
        isWorking = true
        DispatchQueue.global().async {
            FirebaseManager.compendium.updateChallengeRatings {
                isWorking = false
                print("Finished updating challenge ratings!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
