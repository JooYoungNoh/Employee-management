//
//  SceneDelegate.swift
//  EmployeeManagement
//
//  Created by 노주영 on 2022/05/09.
//

import UIKit
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let db = Firestore.firestore()
    
    //내가 방에서 나갈떄 있는 현재 인원
    var searchPhoneList: [String] = []
    var newpresentUser: [String] = []
    var dbResultID: String = ""
    
    let semaphore = DispatchSemaphore(value: 0)
    let group = DispatchGroup()
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        //현재인원에서 나 넣기
        if self.appDelegate.activeChatting == true {
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").getDocument { snapshot2, error2 in
                 if error2 == nil {
                     self.newpresentUser.removeAll()
                     self.searchPhoneList.removeAll()
                     self.newpresentUser = (snapshot2!.data()!["presentUser"] as! [String])
                     self.searchPhoneList = (snapshot2!.data()!["phoneList"] as! [String])
                     
                     self.newpresentUser.append(self.appDelegate.phoneInfo!)
                     
                     self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").updateData([
                         "presentUser" : self.newpresentUser
                     ])
                     
                     if self.appDelegate.presentActive == true {
                         DispatchQueue.global().async {
                             for i in self.searchPhoneList {
                                 self.group.enter()
                                 self.dbResultID = ""
                                 self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                     if error == nil {
                                         for doc in snapshot!.documents{
                                             self.dbResultID = doc.documentID
                                         }
                                         self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").updateData([
                                             "presentUser" : self.newpresentUser
                                         ]){ (_) in
                                             self.semaphore.signal()
                                             self.group.leave()
                                         }
                                     } else {
                                         print(error!.localizedDescription)
                                     }
                                 }
                                 self.semaphore.wait()
                             }
                             self.group.notify(queue: DispatchQueue.main) {
                                  print("끝")
                             }
                         }
                     }
                 } else {
                     print(error2!.localizedDescription)
                 }
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        //현재인원에서 나 빼기
        if self.appDelegate.activeChatting == true {
            self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").getDocument { snapshot2, error2 in
                 if error2 == nil {
                     self.newpresentUser.removeAll()
                     self.searchPhoneList.removeAll()
                     self.newpresentUser = (snapshot2!.data()!["presentUser"] as! [String])
                     self.searchPhoneList = (snapshot2!.data()!["phoneList"] as! [String])
                     
                     if let index = self.newpresentUser.firstIndex(of: self.appDelegate.phoneInfo!){
                         self.newpresentUser.remove(at: index)
                         self.db.collection("users").document("\(self.appDelegate.idInfo!)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").updateData([
                             "presentUser" : self.newpresentUser
                         ])
                         if self.appDelegate.presentActive == true {
                             DispatchQueue.global().async {
                                 for i in self.searchPhoneList {
                                     self.group.enter()
                                     self.dbResultID = ""
                                     self.db.collection("users").whereField("phone", isEqualTo: i).getDocuments { snapshot, error in
                                         if error == nil {
                                             for doc in snapshot!.documents{
                                                 self.dbResultID = doc.documentID
                                             }
                                             self.db.collection("users").document("\(self.dbResultID)").collection("chattingList").document("\(self.appDelegate.dbOnTable)").updateData([
                                                 "presentUser" : self.newpresentUser
                                             ]){ (_) in
                                                 self.semaphore.signal()
                                                 self.group.leave()
                                             }
                                         } else {
                                             print(error!.localizedDescription)
                                         }
                                     }
                                     self.semaphore.wait()
                                 }
                                 self.group.notify(queue: DispatchQueue.main) {
                                      print("끝")
                                 }
                             }
                         }
                     }
                 } else {
                     print(error2!.localizedDescription)
                 }
             }
        }
    }


}

