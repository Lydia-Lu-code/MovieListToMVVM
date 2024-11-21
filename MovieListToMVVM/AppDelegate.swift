

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - App Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        setupUserDefaults()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 保存數據到 UserDefaults
        MovieDataManager.shared.saveToUserDefaults()
    }
    
    private func setupAppearance() {
        // 設置全局外觀
        UINavigationBar.appearance().tintColor = .systemBlue
    }
    
    private func setupUserDefaults() {
        // 初始化默認設置
        let defaults: [String: Any] = [
            "firstLaunch": true,
            "darkMode": false
        ]
        UserDefaults.standard.register(defaults: defaults)
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

