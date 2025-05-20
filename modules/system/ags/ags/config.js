import Bar from './widgets/bar/bar.js'
import App_launcher from './widgets/launcher/app.js'
import Calculator_launcher from './widgets/launcher/calculator.js'
import Clipboard_launcher from './widgets/launcher/clipboard.js'
import Powermenu_launcher from './widgets/launcher/powermenu.js'
import NotificationPopups from './widgets/notifications/popups.js'
import NotificationCenter from './widgets/notifications/center.js'
import Osd from './widgets/osd.js'

import applyCss from './applyCss.js'
applyCss()

import BatteryNotification from './batteryNotification.js'
BatteryNotification()

App.config({
  icons: './icons',
  windows: [Bar(), App_launcher(), Calculator_launcher(), Clipboard_launcher(), Powermenu_launcher(), NotificationPopups(), NotificationCenter(), Osd()],
})
