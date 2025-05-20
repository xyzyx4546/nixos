import Launcher from './launcher.js'

function get_items() {
  return Utils.exec('cliphist list')
    .split('\n')
    .map((clip) => ({
      name: clip.replace(/^\d+\t/, ''),
      icon: 'edit-paste-symbolic',
      on_click: () => Utils.execAsync(`wl-copy ${clip.replace(/^\d+\t/, '')}`),
      filter: (text) =>
        clip
          .replace(/^\d+\t/, '')
          .toLowerCase()
          .includes(text.toLowerCase()),
    }))
}

export default () => Launcher('clipboard', get_items)
