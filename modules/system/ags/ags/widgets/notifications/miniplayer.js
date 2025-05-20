const mpris = await Service.import('mpris')

function lengthStr(length) {
  const min = Math.floor(length / 60)
  const sec = Math.floor(length % 60)
  const sec0 = sec < 10 ? '0' : ''
  return `${min}:${sec0}${sec}`
}

export default function MiniPlayer(player) {
  const img = Widget.Box({
    class_name: 'img',
    vpack: 'start',
    css: player.bind('cover_path').transform(
      (p) => `
            background-image: url('${p}');
        `
    ),
  })

  const title = Widget.Label({
    class_name: 'title',
    wrap: true,
    truncate: 'end',
    hpack: 'start',
    label: player.bind('track_title'),
  })

  const artist = Widget.Label({
    class_name: 'artist',
    wrap: true,
    hpack: 'start',
    xalign: 0,
    label: player.bind('track_artists').transform((a) => a.join(', ')),
  })

  const positionSlider = Widget.Slider({
    class_name: 'position',
    draw_value: false,
    on_change: ({ value }) => (player.position = value * player.length),
    visible: player.bind('length').as((l) => l > 0),
    setup: (self) => {
      function update() {
        const value = player.position / player.length
        self.value = value > 0 ? value : 0
      }
      self.hook(player, update)
      self.hook(player, update, 'position')
      self.poll(1000, update)
    },
  })

  const positionLabel = Widget.Label({
    class_name: 'position',
    vpack: 'start',
    hpack: 'start',
    setup: (self) => {
      const update = (_, time) => {
        self.label = lengthStr(time || player.position)
        self.visible = player.length > 0
      }

      self.hook(player, update, 'position')
      self.poll(1000, update)
    },
  })

  const lengthLabel = Widget.Label({
    class_name: 'length',
    vpack: 'start',
    hpack: 'end',
    visible: player.bind('length').transform((l) => l > 0),
    label: player.bind('length').transform(lengthStr),
  })

  const icon = Widget.Icon({
    class_name: 'icon',
    hexpand: true,
    hpack: 'end',
    vpack: 'start',
    tooltip_text: player.identity || '',
    icon: player.bind('entry').transform((entry) => {
      const name = `${entry}-symbolic`
      return Utils.lookUpIcon(name) ? name : player.identity === 'Spotify Player' ? 'org.gnome.Lollypop-spotify-symbolic' : 'audio-x-generic-symbolic'
    }),
  })

  const playPause = Widget.Button({
    class_name: 'play-pause',
    on_clicked: () => player.playPause(),
    label: player.bind('play_back_status').transform((s) => {
      switch (s) {
        case 'Playing':
          return ''
        case 'Paused':
        case 'Stopped':
          return ''
      }
    }),
  })
  const prev = Widget.Button({
    on_clicked: () => player.previous(),
    label: '',
  })
  const next = Widget.Button({
    on_clicked: () => player.next(),
    label: '',
  })

  const controls = Widget.CenterBox({
    hexpand: true,
    start_widget: positionLabel,
    center_widget: Widget.Box([prev, playPause, next]),
    end_widget: lengthLabel,
  })

  return Widget.Box({
    class_name: 'player',
    vertical: true,
    spacing: 10,
    children: [
      Widget.Box({
        spacing: 10,
        children: [
          img,
          Widget.Box({
            vertical: true,
            hexpand: true,
            children: [Widget.Box([title, icon]), artist],
          }),
        ],
      }),
      Widget.Box({
        vertical: true,
        children: [positionSlider, controls],
      }),
    ],
  })
}
