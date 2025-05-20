import Launcher from './launcher.js'

function get_items() {
  return [
    {
      name: 'shutdown',
      icon: 'system-shutdown-symbolic',
      on_click: () => Utils.exec('systemctl poweroff'),
      filter: (text) => 'shutdown'.includes(text.toLowerCase()),
    },
    {
      name: 'reboot',
      icon: 'system-reboot-symbolic',
      on_click: () => Utils.exec('systemctl reboot'),
      filter: (text) => 'reboot'.includes(text.toLowerCase()),
    },
    {
      name: 'suspend',
      icon: 'system-suspend-symbolic',
      on_click: () => Utils.exec('systemctl suspend'),
      filter: (text) => 'suspend'.includes(text.toLowerCase()),
    },
    {
      name: 'logout',
      icon: 'system-log-out-symbolic',
      on_click: () => Utils.exec('hyprctl dispatch exit'),
      filter: (text) => 'logout'.includes(text.toLowerCase()),
    },
    {
      name: 'lock',
      icon: 'system-lock-screen-symbolic',
      on_click: () => Utils.exec('hyprlock'),
      filter: (text) => 'lock'.includes(text.toLowerCase()),
    },
  ]
}

export default () => Launcher('powermenu', get_items)
