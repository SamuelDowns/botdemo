//
//  BotChatViewController.swift
//  ChatBot2018
//
//  Created by Sam Downs on 12/12/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

class BotChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //  TODO:  - Variable height cells / refine look of cells

    //  TODO:  - Accept text entry - as user message

    //  TODO:  - Accept the intent string

    //  TODO:  - Mock canned sessions

    //  Mock up:  -  Add TIMING to the addition of canned messages to the table
    //    -  Bot interaction w User   (canned)
    //    -  Chat interaction w User  (canned)
    //    ---  Add some canned scenarios...
    //        •  Reset password
    //        •  Order information
    //        •  Gift processing


    //  TODO:  - AWS LEX translation / communication module   ??  (integrate with AWS)



    var canNumber = 1

    var timer : Timer?

    enum TableType {
        case botHeader
        case agentHeader
        case user
        case agent
        case link
    }

    enum CannedSessionType : String {
        case none
        case trackOrder
        case account
        case gift
        case unknown
    }

    struct TableDataStruct {
        let reuseID : String
        let message : String
    }

    var tableData : [TableDataStruct] = []

    var initialIntent : String = "Unknown"
    var canSession : CannedSessionType = .unknown

    var chatActive = false
    var chatResponseIndex = 0

    var botResponseIndex = 0

    let chatResponses : [String] = [ "I see, let me make a change.  How is it now?", "Any additional questions?", "Have a great day!"]

    let botResponses : [String : [String]] =
        ["trackOrder" :
            ["Your order was sent on 12/10."],
        "account" :
            ["Would you like me to reset your password?",
            "I reset the password.  Did that work?",
            "Glad I could help."],
        "gift" :
            ["What's the occasion?",
            "What zip code to send to?",
            "What date to arrive?",
            "I suggest the off-white arrangement.  Good for all occasions."]
    ]

    let botFinalResponse = "Need more help? Try chat."


    @IBOutlet weak var botChatTable: UITableView!
    @IBOutlet weak var entryField: UITextField!
    @IBOutlet weak var chatButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        loadCanData()

        //  Table configuration
        self.botChatTable.separatorStyle = UITableViewCell.SeparatorStyle.none

        botChatTable.rowHeight = UITableView.automaticDimension
        botChatTable.estimatedRowHeight = 65

        entryField?.delegate = self

        chatButton.layer.cornerRadius = 5.0
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //  Start the can timer

        processNextBotResponse()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //  Kill the can timer
        timer?.invalidate()
    }

    func loadCanData() {
        //  Load canned data
        tableData.append(TableDataStruct(reuseID: "botHeader", message: "Welcome to Moxie Bot"))
        //tableData.append(TableDataStruct(reuseID: "agentCell", message: "Welcome to Moxie Bot"))
        tableData.append(TableDataStruct(reuseID: "agentCell", message: initialIntent))
//        tableData.append(TableDataStruct(reuseID: "linkCell", message: "Reset Password"))
//        tableData.append(TableDataStruct(reuseID: "userCell", message: "Thank you"))
//        tableData.append(TableDataStruct(reuseID: "userCell", message: "Thank you"))
//        tableData.append(TableDataStruct(reuseID: "agentCell", message: "Glad that this helped you."))
//        tableData.append(TableDataStruct(reuseID: "agentHeader", message: "Agent Tom joined"))
//        tableData.append(TableDataStruct(reuseID: "agentCell", message: "Have a great day!"))
//        tableData.append(TableDataStruct(reuseID: "agentCell", message: "Have a great day!"))
//        tableData.append(TableDataStruct(reuseID: "userCell", message: "Thank you"))
    }

    func assignIntent(intent:String) {
        initialIntent = intent


        //  Interogate the intent - standard / supported or not? - for canned handling at this time...


        if intent.contains("order") ||
           intent.contains("track") ||
            intent.contains("stuff")
        {
            initialIntent = "Track my order"
            canSession = .trackOrder
            return
        }

        if intent.contains("log") ||
            intent.contains("sign") ||
            intent.contains("account")
        {
            initialIntent = "Help with account"
            canSession = .account
            return
        }

        if intent.contains("gift") ||
            intent.contains("present") ||
            intent.contains("flowers")
        {
            initialIntent = "Help finding a gift"
            canSession = .gift
            return
        }
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    //  MARK: - Table support

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let reuseID = tableData[indexPath.row].reuseID
//
//        switch reuseID {
//        case "linkCell":
//            return 25
//
//        case "botHeader":
//            return 35
//        case "agentHeader":
//            return 55
//
//        default:
//            return 35
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = tableData[indexPath.row].reuseID

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        cell.selectionStyle = .none

        let message = tableData[indexPath.row].message

        switch identifier {
        case "userCell":
            let cell = cell as! UserTableViewCell
            cell.message.text = message

        case "agentHeader":
            if message != "" {
                let cell = cell as! AgentHeaderTableViewCell
                cell.message.text = message
            }

        case "botHeader":
            if message != "" {
                let cell = cell as! BotHeaderTableViewCell
                cell.message.text = message
            }

        case "agentCell":
            let cell = cell as! AgentTableViewCell
            cell.message.text = message

        case "linkCell":
            let cell = cell as! LinkTableViewCell
            cell.message.text = message

        default:
            //  nothing to do here
            return cell
        }

        return cell

    }



    //  MARK: - Text Entry Support

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  Cause end of editing
        hideKeyboard()
        return true
    }

    func textFieldDidBeginEditing(_ textField:UITextField) {
        print("Did start editing")
    }

    func textFieldDidEndEditing(_ textField:UITextField) {
        let value = entryField?.text ?? "Unknown"
        print("did end editing: \(value)")

        userSend(message: value)

        entryField?.text = ""
    }

    func hideKeyboard() {
        entryField?.resignFirstResponder()
    }

    //  MARK: - Mock support

    func userSend(message:String) {
        //  Update table
        self.tableData.append(TableDataStruct(reuseID: "userCell", message: message))
        self.botChatTable.reloadData()

        if chatActive {
            let response = chatResponses[chatResponseIndex]
            chatResponseIndex = chatResponseIndex < chatResponses.count - 1 ? chatResponseIndex + 1 : chatResponseIndex

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                self.tableData.append(TableDataStruct(reuseID: "agentCell", message: response))
                self.botChatTable.reloadData()
                })

            return
        }


        //  Handle Bot sessions here
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            self.processNextBotResponse()
        })


    }

    func processNextBotResponse() {
        // Note there is only one canSession at a time, and the botResponseIndex tracks the progress
        let responseData = botResponses[canSession.rawValue]

        //  If beyond index - suggest a chat
        if responseData == nil || botResponseIndex >= responseData!.count {
            self.tableData.append(TableDataStruct(reuseID: "agentCell", message: botFinalResponse))
            self.botChatTable.reloadData()

            return
        }


        //  Display the next response - and increment
        let message = responseData![botResponseIndex]

        self.tableData.append(TableDataStruct(reuseID: "agentCell", message: message))
        self.botChatTable.reloadData()

        botResponseIndex += 1

    }


    @IBAction func didPressChat(_ sender: Any) {
        //  Hide the chat button
        chatButton.isHidden = true

        print("Did press chat")

        //  Start the Live Agent session
        chatActive = true

        tableData.append(TableDataStruct(reuseID: "agentHeader", message: "Agent Tom joined"))
        botChatTable.reloadData()

        //  Delay the agent message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            self.tableData.append(TableDataStruct(reuseID: "agentCell", message: "Subject: \(self.initialIntent)"))
            self.tableData.append(TableDataStruct(reuseID: "agentCell", message: "How can I help?"))
            self.botChatTable.reloadData()
        })



    }


}
