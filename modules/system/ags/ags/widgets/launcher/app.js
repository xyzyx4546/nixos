const { query } = await Service.import('applications')

import Launcher from './launcher.js'

const excluded = ['NixOS Manual', 'Bulk Rename', 'File Manager Settings', 'File Roller'];

function get_items() {
  return query('')
    .map((app) => ({
      name: app.name,
      icon: app.icon_name,
      on_click: app.launch,
      filter: (text) =>
        app.name
          .toLowerCase()
          .includes(text.toLowerCase())
    }))
    .filter(app => !excluded.includes(app.name));
}

export default () => Launcher('app', get_items)
