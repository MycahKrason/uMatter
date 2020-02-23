//
//  TermsAndPrivacyViewController.swift
//  iMatter
//
//  Created by Mycah on 12/8/19.
//  Copyright © 2019 Mycah Krason. All rights reserved.
//

import UIKit

class TermsAndPrivacyViewController: UIViewController {
    
    @IBOutlet weak var viewTitleDisplay: UILabel!
    
    @IBOutlet weak var informationDisplay: UITextView!
    
    var receivedTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationDisplay.isUserInteractionEnabled = false

        if let title = receivedTitle{
            viewTitleDisplay.text = title
            
            //Dictate the content of the page based on the title that we receive - This will allow for all information to be kept in one place (this view)
            
            if title == "Play List Info"{
                
                informationDisplay.text = "Select a track to listen to it.\n\nYou can save or remove a track from your Favorites by clicking the Circle on the right side of the track.\n\nThe Dark Circle indicates that the track is saved to your Favorites, and the Light Circle means it is not saved to your Favorites."
                
            }else if title == "Builder Info"{
                
                informationDisplay.text = "The Affirmation Builder allows you to customize your Affirmation tracks.\n\nWhen selecting the Affirmations you would like to include in your track, a number will appear on the right side of the Affirmation to indicate the order of which it will play. You can add or remove Affirmations by clicking on them.\n\nYou can also select the background ambience in your Affirmation track. Select the category, then select the specific audio to play on your track using the Picker Selection\n\nIf you would like to clear all of your selected Affirmations and start fresh, press the 'Clear' button. Be aware that you will not be able to recover your playlist once you clear it.\n\nWhen you are ready to build your custom track, press the 'Build' button."
                
            }else if title == "Article List"{
                
                informationDisplay.text = "All articles are from TinyBuddha.com"
                
            }else if title == "Mood Journal"{
                
                informationDisplay.text = "Login to create a Journal.\n\nThen press the +Entry button to add a journal entry.\n\nYou can delete a Journal Entry by clicking on it and selecting \"Delete\"."
                
            }else if title == "Terms / Privacy Policy"{
                
                informationDisplay.text = "Terms & Conditions\nBy downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Hipstatronic LLC.\nHipstatronic LLC is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.\nThe uMatter app stores and processes personal data that you have provided to us, in order to provide our Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the uMatter app won’t work properly or at all.\nYou should be aware that there are certain things that Hipstatronic LLC will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Hipstatronic LLC cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\nIf you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.\nAlong the same lines, Hipstatronic LLC cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Hipstatronic LLC cannot accept responsibility.\nWith respect to Hipstatronic LLC’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Hipstatronic LLC accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\nAt some point, we may wish to update the app. The app is currently available on iOS – the requirements for system (and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Hipstatronic LLC does not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.\n\nChanges to This Terms and Conditions\nWe may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page. These changes are effective immediately after they are posted on this page.\n\nPrivacy Policy\nHipstatronic LLC built the uMatter app as a Commercial app. This SERVICE is provided by Hipstatronic LLC and is intended for use as is.\nThis page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.\nIf you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at uMatter unless otherwise defined in this Privacy Policy.\n\nInformation Collection and Use\nFor a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information that we request will be retained by us and used as described in this privacy policy.\n\nLog Data\nWe want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.\n\nCookies\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.\nThis Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.\n\nService Providers\nWe may employ third-party companies and individuals due to the following reasons:\nTo facilitate our Service;\nTo provide the Service on our behalf;\nTo perform Service-related services; or\nTo assist us in analyzing how our Service is used.\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.\n\nSecurity\nWe value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\nLinks to Other Sites\nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.\n\nChildren’s Privacy\nThese Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.\n\nChanges to This Privacy Policy\nWe may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.\n\nContact Us\nIf you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at Support@Hipstatronic.com."
                
            }
            
        }
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
