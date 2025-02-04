# VideoFlex

## Code Structure

* Configuration 
* Flows - all app screens/flows
* Lifecycle - basic app launch files
* DataManager - main data managers

**DashboardContentView** is the app's main view where we list all the available tools, as well as the list of recently converted files. 

**BottomSheetView** is displayed after the user imports a video. This view is dynamic based on the tool that the user selected. For example: When the user selects Video to GIF, we will simply show a tool to let users select the number of frames per second for the GIF. When the user selects the Merge Videos tool, we show diﬀerent controls in this bottom sheet view. 

**DataManager** is the main manager for the app that handles selected videos, however, we have extensions for this class based on the selected tool. 

You can change the maximum number of seconds for a GIF file, but for best performance we recommend no more than 5 seconds.

You can also update the number of frames per second for a GIF file, but don’t forget to test each change that you make. The more frames per second you set in this file, the longer it will take to convert a video to a GIF file. 

**AppConfig** contains helpful configurations that you can change if required.

## Replace AdMob IDs

1. Open the **Info.plist** file in Xcode. Look for ‘GADApplicationIdentifier’ and replace the existing value with your Google AdMob App ID.
2. Open the **AppConfig.swift** file in Xcode. Look for ‘adMobAdID’ and replace the existing value with your Google AdMob Interstitial Ad ID.

## Change/Create In-App Purchase

### Step 1: Create your IAP product identifier

To create your IAP product identifier, you must have a valid Apple Developer account.

- Go to [App Store Connect](https://appstoreconnect.apple.com)
- Select your app, then click ‘In-App Purchases’ from the Features section on the left side
- On the ‘Create an In-App Purchase’ view, select the type as ‘Non-
Consumable’ then for Reference Name you can type anything you
want, and for the last step ‘Product ID’ you must type your unique In-
App Purchase product identifier.

It’s recommended that you use your bundle identifier plus some extra text at the
end for example: com.yourBundleldentifier.premium

### Step 2: Replace In-App Purchase Identifier

Open the ‘AppConfig.swift’ file in Xcode. Look for
‘premiumVersion’ and replace the existing value with your IAP product identifier that you created in step 1 above.

That’s all you have to do!

### Troubleshooting In-App Purchases

If the IAP price doesn’t show up in the app,
or in the logs you get errors saying “Product no found”, then
follow these steps to troubleshoot the issue:

1. Make sure you test on a real device only

2. Your App Store Connect IAP product identifier must
match the one inside AppConfig

3. If your app is not on TestFlight, make sure to sign in with your
Apple Sandbox ID. To create an Apple Sandbox ID, go to App
Store Connect -> Users and Access and see the Sandbox Testers
on the left side. Create a new Sandbox account here.

4. Check all your contracts, agreements, tax and banking info in App
Store Connect. All must be accepted.

5. Check your in-app purchase product, the status must be
Approved, or Ready to Submit. If your product shows “Missing
Metadata” then you must fill out all the fields in App Store
Connect for your IAP product.

Thank you for your business and feel free to [contact me](https://www.bradbooysen.com/contact) for all your app needs.
Email: hey@bradbooysen.com
