This is my App repository for catarACTION built with Swift 5 in XCode 11.5.
# catarACTION 
catarACTION is an app installed on an iOS device designed to take a fundus/retinal picture of an eye with a 3D-printed attachment.
## Motivation
I decided to create this project during my summer. I realized that it is harder for people with other medical conditions to be diagnosed. This has especially hurt the large numbers of people with serious eye problems who don't have access to the expensive equipment required to diagnose their conditions. Thus, I decided to develop an affordable solution to help people diagnose their conditions because the faster they receive.
## Build Status
Build is succeeding with Travis Continuous Integration Services.
## Code Style
I used a standard code style.
## Tech/Framework Used
App is built with XCode 11.5
## Features
My project uses AVCamera Foundation to help the user take better photos - zoom and flash is allowed, and the image automatically focuses. Furthermore, for ease of the user, the image shows up in a preview and, if approved, is sent to a separate view controller and analyzed.
## Installation
No specifc installation is required, but the app does take up quite a bit of space due to the model.
## How to Use?
The app is fairly self-explanatory, but when the user first opens the app, they must sign up to create an account. Then they are taken to a 'home screen' with two tabs: camera and settings. Take a photo of someone's eye with the attachment, approve the image in the 'preview' page by tapping the upload button, and then you will automatically be redirected to another page, or the 'analysis' page. Once you are done examining the result, swipe down, and you will be back at the camera. If you want some other options, you can tap the settings button. Once you log out, you will be taken back to the 'default' page and can either choose to create a new account or log back in.
