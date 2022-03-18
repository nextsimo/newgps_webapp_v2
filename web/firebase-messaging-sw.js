importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0",
  authDomain: "react-native-firebase-testing.firebaseapp.com",
  databaseURL: "https://react-native-firebase-testing.firebaseio.com",
  projectId: "react-native-firebase-testing",
  storageBucket: "react-native-firebase-testing.appspot.com",
  messagingSenderId: "448618578101",
  appId: "1:448618578101:web:ecaffe2bc4511738",
});





self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  console.log("-----> notificationclick");
  // fcp_options.link field from the FCM backend service goes there, but as the host differ, it not handled by Firebase JS Client sdk, so custom handling
  if (event.notification && event.notification.data && event.notification.data.FCM_MSG && event.notification.data.FCM_MSG.notification) {
    const url = 'https://newgps-323d9.web.app';
    event.waitUntil(
      self.clients.matchAll({ includeUncontrolled: true, type: 'window' }).then(windowClients => {
        // Check if there is already a window/tab open with the target URL
        console.log(windowClients);
        console.log(self.clients);
        console.log(event.notification.data);
        /*                 var res = await self.clients.get({type: 'window'});
                        console.log(res); */
        for (var i = 0; i < windowClients.length; i++) {
          var client = windowClients[i];
          console.log(client.url);
          // If so, just focus it.
          client.focus();
        }
        // If not, then open the target URL in a new window/tab.
        if (self.clients.openWindow) {
          console.log("open window")
          return self.clients.openWindow(url + '/alert');
        }
      })
    )
  }
  //window.open('https://newgps-323d9.web.app', '_blank');
}, false);

const messaging = firebase.messaging();

/*
// Necessary to receive background messages:


// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
 // window.open('https://newgps-323d9.web.app/#/navigation/1', '_blank');
}); */