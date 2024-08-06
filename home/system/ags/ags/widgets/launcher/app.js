const { query } = await Service.import('applications')

import Launcher from './launcher.js'

function get_command(app) {
  if(Utils.readFile(app.app.filename).includes('Terminal=true')) {
    return Utils.execAsync(['zsh', '-c', `kitty ${app.executable}`])
  } else {
    return app.launch()
  }
}

function get_items() {
  return query('').map((app) => ({
    name: app.name,
    icon: app.icon_name,
    on_click: () => Utils.readFile(app.app.filename).includes('Terminal=true')
      ? Utils.execAsync(['zsh', '-c', `kitty ${app.executable}`])
      : app.launch(),
    filter: app.match,
  }))
}

export default () => Launcher('app', get_items)
