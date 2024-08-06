const power_revealed = Variable(false)

const revealer = Widget.Revealer({
  transition: 'slide_left',
  reveal_child: power_revealed.bind(),
  child: Widget.Box({
    children: [
      Widget.Button({
        class_name: 'power-button revealed',
        child: Widget.Icon({ icon: 'system-lock-screen-symbolic' }),
        on_clicked: () => Utils.exec('hyprlock'),
      }),
      Widget.Button({
        class_name: 'power-button revealed',
        child: Widget.Icon({ icon: 'system-log-out-symbolic' }),
        on_clicked: () => Utils.exec('hyprctl dispatch exit'),
      }),
      Widget.Button({
        class_name: 'power-button revealed',
        child: Widget.Icon({ icon: 'system-suspend-symbolic' }),
        on_clicked: () => Utils.exec('systemctl suspend'),
      }),
      Widget.Button({
        class_name: 'power-button revealed',
        child: Widget.Icon({ icon: 'system-reboot-symbolic' }),
        on_clicked: () => Utils.exec('systemctl reboot'),
      }),
    ],
  }),
})

function toggleRevealer() {
  power_revealed.setValue(true)

  const position = JSON.parse(Utils.exec('hyprctl -j layers'))['DP-3']['levels']['2'].find((layer) => layer.namespace === 'bar')

  const intervalId = setInterval(() => {
    const cursor_pos = JSON.parse(Utils.exec('hyprctl -j cursorpos'))
    if (cursor_pos.y > position.y + position.h) {
      power_revealed.setValue(false)
      clearInterval(intervalId)
    }
  }, 100)
}

export default function Power() {
  return Widget.Box({
    class_name: power_revealed.bind().as((p) => `power ${p === true ? 'revealed' : ''}`),
    children: [
      revealer,
      Widget.Button({
        class_name: power_revealed.bind().as((p) => `power-button ${p === true ? 'revealed' : ''}`),
        child: Widget.Icon({ icon: 'system-shutdown-symbolic' }),
        on_clicked: () => {
          if (revealer.reveal_child) {
            Utils.exec('systemctl poweroff')
          } else {
            toggleRevealer()
          }
        },
      }),
    ],
  })
}
