const mpris = await Service.import('mpris')
const network = await Service.import('network')
const audio = await Service.import('audio')
const notifications = await Service.import('notifications')
const hyprland = await Service.import('hyprland')

const notification_center_revealed = Variable(false)

let intervalId
function openNotificationCenter() {
  if (notification_center_revealed.value) {
    notification_center_revealed.setValue(false)
    App.closeWindow('notification_center')
    if (intervalId) clearInterval(intervalId)
    return
  }

  notification_center_revealed.setValue(true)
  App.openWindow('notification_center')

  Utils.timeout(100, () => {
    intervalId = setInterval(() => {
      const position = JSON.parse(Utils.exec('hyprctl -j layers'))['DP-3']['levels']['2'].find((layer) => layer.namespace === 'notification_center')

      const cursor_pos = JSON.parse(Utils.exec('hyprctl -j cursorpos'))
      if (cursor_pos.x < position.x) {
        notification_center_revealed.setValue(false)
        App.closeWindow('notification_center')
        clearInterval(intervalId)
      }
    }, 100)
  })
}

function element(icon, tooltip, visible) {
  return Widget.Revealer({
    transition: 'slide_left',
    reveal_child: visible,
    child: Widget.Icon({
      class_name: notification_center_revealed.bind().as((s) => `sysmenu-element ${s === true ? 'revealed' : ''}`),
      tooltip_text: tooltip,
      icon: icon,
    }),
  })
}

export default function Indicators() {
  return Widget.Button({
    class_name: notification_center_revealed.bind().as((s) => `sysmenu ${s === true ? 'revealed' : ''}`),
    on_clicked: () => openNotificationCenter(),
    child: Widget.Box({
      children: [
        element(
          'applications-games-symbolic',
          '',
          hyprland.bind('workspaces').as(ws => (ws?.find(w => w.name === 'special:games')?.windows ?? 0) >= 1 ? true : false)
        ),
        element(
          'emblem-music-symbolic',
          '',
          mpris.bind('players').as((p) => p.length > 0)
        ),
        element(
          network.bind('connectivity').as((n) => (n === 'none' ? 'network-wired-offline-symbolic' : 'network-wired-symbolic')),
          '',
          true
        ),
        element(
          Utils.merge([audio.speaker.bind('volume'), audio.speaker.bind('is_muted')], (volume, isMuted) => ({ volume, isMuted })).as(
            ({ volume, isMuted }) => `audio-volume-${isMuted ? 'muted' : volume === 0 ? 'low' : volume < 0.49 ? 'medium' : 'high'}-symbolic`
          ),
          audio.speaker.bind('volume').as((v) => `Volume: ${Math.round(v * 100)}%`),
          true
        ),
        element(
          'notifications-symbolic',
          notifications.bind('notifications').as((n) => n.length.toString()),
          notifications.bind('notifications').as((n) => n.length > 0)
        ),
      ],
    }),
  })
}
