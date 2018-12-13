//
//  BotChatViewController.swift
//  ChatBot2018
//
//  Created by Sam Downs on 12/12/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

class BotChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //  TODO:  - Table view with 5 types of cells

    //     - Variable height cells
    //     - Refine the look of the table cells
    //     - Accept text entry - as user message


    //  TODO:  - Accept the intent string


    //  Mock up:  -  Add TIMING to the addition of canned messages to the table
    //    -  Bot interaction w User   (canned)
    //    -  Chat interaction w User  (canned)
    //    ---  Add some canned scenarios...
    //        •  Reset password
    //        •  Order information
    //        •  Gift processing



    //     - AWS LEX translation / communication module   ??  (integrate with AWS)



    var canNumber = 1

    var timer : Timer?

    enum TableType {
        case botHeader
        case agentHeader
        case user
        case agent
        case link
    }

    struct TableDataStruct {
        let reuseID : String
        let message : String
    }

    var tableData : [TableDataStruct] = []


    @IBOutlet weak var botChatTable: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        loadCanData()

        self.botChatTable.separatorStyle = UITableViewCell.SeparatorStyle.none
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //  Start the can timer
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //  Kill the can timer
        timer?.invalidate()
    }

    func loadCanData() {
        //  Load canned data
        tableData.append(TableDataStruct(reuseID: "botHeader", message: ""))
        tableData.append(TableDataStruct(reuseID: "agentCell", message: "Welcome to Moxie Bot"))
        tableData.append(TableDataStruct(reuseID: "linkCell", message: "Reset Password"))
        tableData.append(TableDataStruct(reuseID: "userCell", message: "Thank you"))
        tableData.append(TableDataStruct(reuseID: "agentHeader", message: ""))
        tableData.append(TableDataStruct(reuseID: "agentCell", message: "Have a great day!"))
    }
    


    //  MARK: - Table support

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


    @IBAction func didPressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}
