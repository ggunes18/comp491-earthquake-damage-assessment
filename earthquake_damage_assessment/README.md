# Earthquake Help Joint Platform - KuHelp

This repository contains the source code for the Earthquake Help Joint Platform - KuHelp, a mobile app developed using Flutter, Firebase Auth, Firebase Firestore, and Google Maps API. The app aims to build an app, catering to anyone in need of immediate assistance during an earthquake by linking individuals and the government or first aid NGOs. One of the most challenging problems that rescuers faced during the earthquake was the lack of communication, they did not sure whether help is sent or any progress is made. KuHelp's biggest advantage is enabling rescuers to track the status and gather data.

## Features

- **Victim Requests:** Victims can send different types of requests, which are saved in the Firebase Firestore database. They can also track the status of their requests.
- **Helper Dashboard:** Helpers can view all the requests on a map and update the status of each request based on their progress in providing assistance.
- **Google Maps Integration:** Both victims and helpers have access to Google Maps, with different functionalities:
    - Victims can view safe locations marked on the map to help them find a safe place during an earthquake.
    - Helpers can see all the requests geographically represented on the map, allowing them to identify areas that require immediate assistance.
- **Authentication and Authorization:** Firebase Auth is used to handle user authentication, ensuring that only authorized individuals can access the app's functionalities.
- **Firebase Firestore:** The app leverages Firebase Firestore as the backend database to store and manage victim requests and their status updates.

## Prerequisites

To run the Earthquake Helper App, you'll need to have the following:

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Firebase Console](https://console.firebase.google.com/)
  - Firebase project set up with Firebase Auth and Firestore enabled
  - Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) placed in the appropriate locations in the Flutter project

## Getting Started

1. Clone this repository:

```shell
git clone https://github.com/ggunes18/comp491-earthquake-damage-assessment.git
```

2. Navigate to the project directory:

```shell
cd earthquake_damage_assessment
```

3. Install the Flutter dependencies:

```shell
flutter pub get
```

4. Run the app:

```shell
flutter run
```

Please note that you'll need a device (emulator or physical device) connected to your development environment to run the app.

## Contact
If you have any questions or suggestions regarding the Earthquake Helper App, feel free to contact us at:
bberktay19@ku.edu.tr

beyzagundogan19@ku.edu.tr

ggunes18@ku.edu.tr

yerdemirler18@ku.edu.tr


Thank you for your interest in our project! We hope the KuHelp can make a positive impact in connecting victims with helper organizations during earthquakes or any kind of disasters.
