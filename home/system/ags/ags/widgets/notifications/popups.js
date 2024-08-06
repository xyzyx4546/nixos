const notifications = await Service.import('notifications')

import Notification from './notification.js'

export default function NotificationPopups() {
  return Widget.Window({
    name: `notification_popups`,
    class_name: 'notification-popups',
    monitor: 0,
    anchor: ['top'],
    layer: 'overlay',
    child: Widget.Box({
      class_name: 'notifications',
      vertical: true,
      children: notifications.bind('popups').as((popups) => popups.reverse().map(Notification)),
    }),
  })
}
