//
//  PromptView.swift
//  Soulprint
//
//  Created by Max Hoff on 6/26/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Yams

let fontColor2 = Color(UIColor(red: 0.2, green: 0.3, blue: 0.8, alpha: 1))

struct PromptView: View {
    let dailyPrompts = ["What was the high of your day?", "What was the low of your day?", "What was the best moment from your day?", "What was the strongest feeling you had?", "What was the most frustrating experience from today?", "What was the saddest you felt today?", "Use several words to describe your day", "How would you rate your day out of 10 and why?"]
    @State private var deepDivePrompts = ["What's your story?", "What tips would you give to a younger self?", "What movie or book do you consider almost perfect? Why?", "What do you think the future will look like in 100 years?", "What do you feel most grateful for in life?", "Who are the most important people in your life?", "What was the worst day of your life?", "What is your favorite sound?", "Pick a year and summarize that year and discuss highs and lows. (Repeatable)", "What’s your favorite song and what feelings does it bring up?", "What’s the funniest story you have?", "Who have your role models been over time?", "Who’s your favorite celebrity and why?", "What's a subject you are most knowledgeable about? Speak to it for ten minutes", "What are you an expert in but you don't have formal education?", "What are some of your most controversial opinions?", "Which political causes do you care about most? Why?", "If you can have coffee with anyone in the world who would it be and why?", "Who are your closest friends and what do they mean to you?", "Who are your favorite musical artists? Right now and of all time?", "How has your music taste changed over time?", "Best concert and why?", "Pick a friend/family member and say what you admire about them and what you've learned from them (Repeatable)", "Pick a musical artist and say why you like them? (Repeatable)", "Pick an album and say what you like about it and why? (Repeatable)", "Pick a song and describe what you like about it. (Repeatable)", "Pick a photo and explain the context and why it's important to you. (Repeatable)", "Pick a subject that you're knowledgeable about and discuss it for five minutes. (Repeatable)", "Pick a meal you’ve had and discuss why it's important to you. (Repeatable)", "Pick a memory and discuss why it stands out. (Repeatable)", "What would the perfect meal look like to you?", "Best vacation you've had?", "Worst vacation you've had?", "What is your favorite quality about yourself?", "What area have you grown the most over the past year? (Repeatable but for 5/10/20 years)", "What is your favorite holiday? Why?", "Most thoughtful gift you’ve ever received and who it came from?", "If you could go back and redo anything in your life, what would you do?", "What general advice can you give to someone about making a relationship successful?", "What has been the most surprising thing about growing up?", "What’s one fear you’d like to overcome?", "If money wasn’t an issue, what hobby would you like to do?", "In what way are you breaking (or would like to break) a childhood generational curse with your children?", "What are your guilty pleasures?", "Do you think there's life after death? If so, what do you think it might it look like?", "Would you like to be famous? In what way?", "What would be a perfect day for you?", "What is your wisest piece of advice?", "Is there something you've dreamed of doing for a while? Why haven't you done it?", "What is your greatest accomplishment?", "What do you value most in a friendship?", "What is your most terrible memory?", "What is the most difficult thing you've ever been through?", "What is the saddest thing that's ever happened to you?", "If you knew you were going to die in one year, what would you do differently?", "What roles do love and affection play in your life?", "What characteristics do you admire most in other people?", "What characteristics do you admire most in you closest friends/family? Be specific.", "How close and warm is your family? Do you feel like your childhood was happier than most people?", "How do you feel about your relationship with your mother?", "What is one thing you think is surprising about yourself?", "Complete this sentence: I wish I had someone with who I could share...", "If you were to become close friends with someone, what is one thing you would want them to know?", "Share an embarrasing moment in your life", "When did you last cry in front of another person? By yourself?", "What if anything is too serious to joke about?", "If you were to die today, what would you most regret not telling someone? Why haven't you told them?", "What item would you take with you to an island you're stranded on?", "Of all the people you're close with, whose death would you find most disturbing? Why?", "Share a personal problem you are currently dealing with.", "What do you think about abortion?", "What do you think about immigration?", "What are your thoughts on the titanic submarine disaster?", "What do you think about recreational drug use? Which drugs are okay?", "What do you think about traveling to mars?", "What do you think about assisted death?", "What do you think about the war in Ukraine?", "What do you think about artificial intelligence?", "What do you think about plastic surgery?", "What do you think about gun rights?", "How would you fix the problems in your country?", "What does an ideal society look like to you?", "If you could teleport to any place and time, where would it be?", "How do you feel about human nature? Is it inherently good or bad?"]
    
    @State private var selectedPromptSetIndex = 0 {
        didSet {
            selectedPromptIndex = 0
        }
    }
    @State private var selectedPromptIndex = 0
    @State private var isVideoRecording = false
    @State private var videoURL: URL? = nil
    @Binding var loggedIn: Bool
    let db = Firestore.firestore()
    @State private var answeredPrompts: [String: Date] = [:]
    @ObservedObject private var userViewModel = UserViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Picker("Prompt Set", selection: $selectedPromptSetIndex) {
                        Text("Daily").tag(0)
                        Text("Deep Dive").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 50)
                    
                    ScrollView {
                        VStack {
                            let prompts = promptsForSelectedSet()
                            ForEach(prompts.indices, id: \.self) { index in
                                Button(action: {
                                    selectedPromptIndex = index
                                    isVideoRecording = true
                                    let prompt = prompts[index]
                                    // Update the last answered date in Firestore.
                                    let userDocument = db.collection("users").document(currentUser()!)
                                    let newAnswer: [String: Any] = [prompt: FieldValue.serverTimestamp()]
                                    userDocument.setData([
                                        "answers": newAnswer
                                    ], mergeFields: ["answers.\(prompt)"])
                                    // Update userViewModel.user directly
                                    userViewModel.user?.answers[prompt] = Date()
                                }) {
                                    HStack {
                                        Text(prompts.indices.contains(index) ? prompts[index] : "Default Value")
                                            .font(.title2.bold())
                                            .foregroundColor(fontColor)
                                        if index < prompts.count, answeredToday(prompt: prompts[index]) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
                                    .padding([.top, .bottom], 10)
                                    .padding([.leading, .trailing], 4)
                                    .background(buttonColor.shadow(color: .black, radius: 5, x: 0, y: 2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(fontColor, lineWidth: 2)
                                    )
                                    .padding([.leading, .trailing], 10)
                                }
                            }
                            .padding([.top, .bottom], 3)
                        }
                    }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            signOut()
                        }) {
                            Text("Sign Out")
                                .font(.headline.bold())
                                .foregroundColor(fontColor2) // Changes the text color to forest green.
                        }
                        .padding()
                        Spacer()
                        
                        NavigationLink(destination: InformationView()) {
                            Image(systemName: "info.circle") // 'info.circle' is the system image for lowercase 'i' with a circle
                                .font(.title2)
                                .padding()
                        }

                    }
                    Spacer()
                }
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .foregroundColor(fontColor)
            .sheet(isPresented: $isVideoRecording) { // Present VideoRecorder when isVideoRecording is true
                VideoRecorder(isShown: $isVideoRecording, videoURL: $videoURL, questionID: self.getQuestionID(), userID: self.currentUser()!)
            }
            .onAppear {
                // Set up a timer to clear answeredPrompts at 4am.
                setUpResetTimer()
                userViewModel.fetchUser()
                
                NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: .main) { _ in
                    self.userViewModel.user?.answers.removeAll()
                }
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.loggedIn = false
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    private func promptsForSelectedSet() -> [String] {
        switch selectedPromptSetIndex {
        case 0:
            return dailyPrompts
        case 1:
            return deepDivePrompts
        default:
            return []
        }
    }

    private func getQuestionID() -> String {
        let prompt = promptsForSelectedSet()[selectedPromptIndex]
        let promptDocument = db.collection("questions_key").document() // This generates a new document with a unique ID.
        promptDocument.setData(["question": prompt]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        return promptDocument.documentID // Returns the unique ID.
    }
    
    private func currentUser() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    private func answeredToday(prompt: String) -> Bool {
        guard let user = userViewModel.user else { return false }
        guard let answerDate = user.answers[prompt] else { return false }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!  // Use UTC timezone
        let nowComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let answerComponents = calendar.dateComponents([.day, .month, .year], from: answerDate)

        return nowComponents == answerComponents
    }
    
    private func setUpResetTimer() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!  // Use UTC timezone
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 4
        components.minute = 0
        components.second = 0

        if let nextResetDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime) {
            let timeUntilReset = nextResetDate.timeIntervalSince(Date())
            Timer.scheduledTimer(withTimeInterval: timeUntilReset, repeats: true) { _ in
                self.userViewModel.user?.answers.removeAll()
            }
        } else {
            print("Could not find the next reset date.")
        }
    }
}

struct User: Identifiable {
    let id: String
    var answers: [String: Date]
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        let answersDict = dictionary["answers"] as? [String: Timestamp] ?? [:]
        var answers: [String: Date] = [:]
        for (key, value) in answersDict {
            answers[key] = value.dateValue()
        }
        self.answers = answers
    }
}

class UserViewModel: ObservableObject {
    private let db = Firestore.firestore()
    @Published var user: User? = nil
    
    func fetchUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).addSnapshotListener { document, error in
            guard let document = document, document.exists, let data = document.data() else { return }
            self.user = User(id: document.documentID, dictionary: data)
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(loggedIn: .constant(true))
    }
}
