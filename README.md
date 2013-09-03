first-ios-app
=============

The first iOS app I did as my thesis work at the University of Pannonia.

The application is designed to aid managing utility bills and consumption. It allows the users to store energy and water consumption data.It can set reminders to notify about bill payment deadlines. The application shows consumption statistics on a graph as well as provides the opportunity to search nearby post offices on a map.

The functions of the application:
- stores places and meters in a database,
- saves meter readings and bills to the meters,
- shows utility and other bills in a calendar by due date,
- notifies about bill payment deadlines,
- shows consumption data on a graph,
- provides the opportunity to search post offices near the current location

Please note:
- The post office search is static and bound to a specific location in this version. It is due to the possible iOS API bug of the mapview:regionDidChangeAnimated: method not getting called when the user navigates the map view.
- In some cases navigating the calendar would crash the application. This could be a bug of the Kal component, further investigation is needed.
- The graphing feature is not fully implemented and crashes the application.
- The application was never tested on a physical device.
