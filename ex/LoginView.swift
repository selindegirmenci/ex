import Foundation
import Firebase
import SwiftUI


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    func getPrivateVar() -> Bool {
        return userIsLoggedIn
    }
    var body: some View {
        if userIsLoggedIn {
            // GO TO PAGE
            ContentView()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.blue, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1200, height: 600)
                .rotationEffect(.degrees(135))
                .offset(x: 420, y: 240)
            
            VStack(spacing: 20) {
                Text("Welcome SAMSUNG,")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -50, y: -50)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email")
                        .foregroundColor(.white)
                        .bold()
                    
                    TextField("", text: $email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.white, lineWidth: 1))
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .foregroundColor(.white)
                        .bold()
                    
                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.white, lineWidth: 1))
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                
                Button {
                    // sign up
                    register()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(LinearGradient(colors: [.blue, .green], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding()
                
                Button {
                    // login
                    login()
                } label: {
                    Text("Log Into Existing Account")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in if user != nil { userIsLoggedIn.toggle() } }
            }
        }
        .ignoresSafeArea()
    }

    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in if error != nil {
            print(error!.localizedDescription)
        }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in if error != nil {
            print(error!.localizedDescription)
        }
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


