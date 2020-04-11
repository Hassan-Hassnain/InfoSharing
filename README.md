#  Google Calendar Event
stackoverflow link: 
[https://stackoverflow.com/questions/47801031/adding-a-google-calendar-event-in-swift]

I was facing the same problem during the lack of resources at this topic, those are the steps

->configure your app with google calendar account

1-go to [https://console.developers.google.com/] add a new project with app bundle id and name

2- go to dashboard click Enable APIS AND SERVICES then choose a calendar API Service and enable It.

3-choose credentials from the side menu and click CREATE CREDENTIALS Link from top of the page and add OAuth Client ID

download plist from [https://console.developers.google.com/apis/credentials/oauthclient/750374453418-363del5odp0q8a5f5oggsmqg78e0519i.apps.googleusercontent.com?folder=&organizationId=&project=calanderevent]

4- Add all properties of this file in [GoogleService-info-plist]  if exist

5- add schemes url in info 

6- Integrating Google Sign-In into your iOS app


