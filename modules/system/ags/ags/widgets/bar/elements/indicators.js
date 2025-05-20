const mpris = await Service.import('mpris')
const network = await Service.import('network')
const audio = await Service.import('audio')
const notifications = await Service.import('notifications')
const hyprland = await Service.import('hyprland')
const battery = await Service.import('battery')

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
      const layers = JSON.parse(Utils.exec('hyprctl -j layers'))
      const position = (layers['DP-3'] || layers['eDP-1'])['levels']['2'].find((layer) => layer.namespace === 'notification_center')

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
          network.bind('primary').as((p) => p === 'wired' ? network.wired.icon_name : network.wifi.icon_name),
          '',
          true
        ),
        element(
          Utils.merge([audio.speaker.bind('volume'), audio.speaker.bind('is_muted')], (volume, isMuted) => ({ volume, isMuted })).as(
            ({ volume, isMuted }) => `audio-volume-${isMuted ? 'muted' : volume === 0 ? 'low' : volume < 0.49 ? 'medium' : 'high'}-symbolic`
          ),
          audio.speaker.bind('volume').as((v) => `${Math.round(v * 100)}%`),
          true
        ),
        element(
          battery.bind('icon_name'),
          battery.bind('percent').as((p) => `${p}%`),
          battery.bind('available')
        ),
        element(
          'notification-symbolic',
          notifications.bind('notifications').as((n) => n.length.toString()),
          notifications.bind('notifications').as((n) => n.length > 0)
        )
      ],
    }),
  })
}
