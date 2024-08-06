const audio = await Service.import('audio')
let volume = audio.speaker.volume
let isMuted = audio.speaker.is_muted

let timeoutId
export function open() {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }

  App.openWindow('volume_OSD')

  timeoutId = setTimeout(() => {
    App.closeWindow('volume_OSD')
  }, 2000)
}

export default function VolumeOSD() {
  return Widget.Window({
    name: 'volume_OSD',
    class_name: 'volume_OSD',
    monitor: 0,
    visible: false,
    anchor: ['bottom'],
    layer: 'overlay',
    margins: [0, 0, 70, 0],
    child: Widget.Box({
      class_name: 'volume-box',
      spacing: 10,
      children: [
        Widget.Icon({
          icon: Utils.merge([audio.speaker.bind('volume'), audio.speaker.bind('is_muted')], (volume, isMuted) => ({ volume, isMuted })).as(
            ({ volume, isMuted }) => `audio-volume-${isMuted ? 'muted' : volume === 0 ? 'low' : volume < 0.49 ? 'medium' : 'high'}-symbolic`
          ),
        }),
        Widget.Label({
          label: audio.speaker.bind('volume').as((volume) => `${Math.round(volume * 100)}%`),
          css: 'min-width: 55px;',
        }),
        Widget.Slider({
          class_name: 'volume-slider',
          draw_value: false,
          hexpand: true,
          value: audio.speaker.bind('volume'),
          on_change: ({ value }) => {
            audio.speaker.volume = value
            open()
          },
        }),
      ],
    }),
  })
}
