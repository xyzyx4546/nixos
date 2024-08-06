const notifications = await Service.import('notifications')
const mpris = await Service.import('mpris')
const players = mpris.bind('players')

import Notification from './notification.js'
import Miniplayer from './miniplayer.js'

export default function NotificationCenter() {
  return Widget.Window({
    name: `notification_center`,
    class_name: 'notification-center',
    monitor: 0,
    visible: false,
    anchor: ['top', 'right'],
    child: Widget.Box({
      spacing: 20,
      vertical: true,
      children: [
        Widget.Box({
          class_name: 'notifications',
          vertical: true,
          children: [
            Widget.Box({ vertical: true, children: notifications.bind('notifications').as((notifications) => notifications.map(Notification)) }),
            Widget.Label({
              class_name: 'no-notifications',
              visible: notifications.bind('notifications').as((notifications) => notifications.length === 0),
              label: 'No notifications',
            }),
            Widget.Button({
              class_name: 'clear-all',
              hpack: 'end',
              label: 'Clear all',
              on_clicked: () => notifications.clear(),
            }),
          ],
        }),
        Widget.Box({
          class_name: 'miniplayers',
          vertical: true,
          children: mpris.bind('players').as((players) => players.map(Miniplayer)),
        }),
      ],
    }),
  })
}
