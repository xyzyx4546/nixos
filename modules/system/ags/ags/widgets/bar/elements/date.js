const time = Variable('', { poll: [1000, 'date "+%H:%M"'] })
const date = Variable('', { poll: [1000, 'date "+%d.%m.%Y"'] })

export function Time() {
  return Widget.Label({
    class_name: 'clock',
    hpack: 'end',
    label: time.bind(),
  })
}
export function Date() {
  return Widget.Label({
    class_name: 'clock',
    hpack: 'start',
    label: date.bind(),
  })
}
