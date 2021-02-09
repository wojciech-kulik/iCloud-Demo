# iCloud Demo

Sample iOS project showing how to implement and use iCloud services.

## Features
- CloudKit API - simple database using CloudKit
- CloudKit + CoreData - simple database using CoreData with iCloud
- iCloud Documents - iCloud files synchronization
- Key-Value storage - UserDefaults stored in iCloud

## Required Project Setup
Follow steps in this specific order. Remember, once you create an iCloud container, it can't be removed or edited, so be careful with the name. 

1. Open `iCloud Demo.entitlements` file and replace `iCloud.com.company.icloud-demo` with your own. It must start with `iCloud.`
2. Go to project settings, select your target, select "Signing & Capabilities".
3. Change bundle id to whatever you want.
4. Select your TEAM.
5. Open `AppConstants.swift` and replace container ID with your own.

It should generate provisioning profiles and create iCloud container. If iCloud container is highlighted with red color, try to refresh it or uncheck and check again.

## Testing
Some features like CoreData automatic sync require real device. In this case, CoreData is using under the hood push notifications to track changes.

## Simulator
You can also try it out on simulator, however you need to sign in with your Apple ID to enable iCloud. Also syncing is working worse than on real device, therefore sometimes you may encounter some delays.
Use `Features -> Trigger iCloud Sync`  from simulator's menu to trigger synchronization.
