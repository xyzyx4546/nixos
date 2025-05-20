const audio = await Service.import('audio')
import brightness from '../services/brightness.js'

const type = Variable('')
const value = Utils.merge([type.bind(), audio.speaker.bind('volume'), brightness.bind('screen_value')], (type, volume, brightness) => {
  switch (type) {
    case 'volume':
      return volume
    case 'brightness':
      return brightness
    default:
      return 0
  }
})

const icon = Widget.Stack({
  children: {
    volume: Widget.Icon({
      icon: Utils.merge([audio.speaker.bind('volume'), audio.speaker.bind('is_muted')], (volume, isMuted) => ({ volume, isMuted })).as(
        ({ volume, isMuted }) => `audio-volume-${isMuted ? 'muted' : volume === 0 ? 'low' : volume < 0.49 ? 'medium' : 'high'}-symbolic`
      )
    }),
    brightness: Widget.Icon({
      icon: brightness.bind('screen_value').as((b) => `display-brightness-${b < 0.49 ? 'medium' : 'high'}-symbolic`)
    }),
  },
  // @ts-ignore
  shown: type.bind()
})

let timeoutId
export function open(t) {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }

  type.setValue(t)

  App.openWindow('osd')

  timeoutId = setTimeout(() => {
    App.closeWindow('osd')
  }, 2000)
}

export default function Osd() {
  return Widget.Window({
    name: 'osd',
    class_name: 'OSD',
    monitor: 0,
    visible: false,
    anchor: ['bottom'],
    layer: 'overlay',
    margins: [0, 0, 70, 0],
    child: Widget.Box({
      class_name: 'osd-box',
      spacing: 10,
      children: [
        icon,
        Widget.Label({
          label: value.as((v) => `${Math.round(v * 100)}%`),
          css: 'min-width: 55px;',
        }),
        Widget.Slider({
          class_name: 'osd-slider',
          draw_value: false,
          hexpand: true,
          value: value,
          on_change: ({ value }) => {
            switch (type.value) {
              case 'volume':
                audio.speaker.volume = value
              case 'brightness':
                brightness.screen_value = value
            }
            open(type.value)
          },
        }),
      ],
    }),
  })
}
