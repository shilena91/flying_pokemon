# flying_pokemon

A new Flutter project, the challenge is displaying a list of pokemons from an API.

## Usage (for MacOS)
- Clone the repo.
> git clone https://github.com/shilena91/flying_pokemon
- Open Terminal and run command ```which flutter``` to check if your system has Flutter SDK. If it has you can skip the install Flutter step below.
### Install Flutter SDK
- You can follow the install steps from [here](https://flutter.dev/docs/get-started/install/macos).
- After succesfully install Flutter SDK, from Terminal go to the cloned directory and run command ```flutter pub get```
### Running the app on VSCode
- To setup flutter on VSCode, follow the steps from [here](https://flutter.dev/docs/get-started/editor?tab=vscode)
- Open the cloned repo by VSCode and run, remember to run command ```flutter doctor``` on Terminal to check flutter enviromment.
### Running the app on XCode
- Install CocoaPods by running commands:
> $ sudo gem install cocoapods\
> $ pod setup
- In cloned directory, go to ios directory and run command ```pod install```, you don't need to do this step if you already ran the app on VSCode before.
- In ios directory, open file ***Runner.xcworkspace*** by Xcode, choose iOS simulator, run and see the app. If you want to run on physical device you need to configure the app's ***Team*** and ***Bundle Identifier*** to your preferences. 
