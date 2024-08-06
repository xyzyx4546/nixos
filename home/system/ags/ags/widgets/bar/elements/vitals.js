const cpu = Variable(0, {
  poll: [
    1000,
    'top -b -n 1',
    (out) =>
      Number.parseInt(
        out
          .split('\n')
          .find((line) => line.includes('Cpu(s)'))
          ?.split(/\s+/)[1]
          .replace(',', '.') ?? '0'
      ) / 100,
  ],
})
const ram = Variable([0, 0], {
  poll: [
    1000,
    'free -b',
    (out) =>
      out
        .split('\n')
        .find((line) => line.includes('Mem:'))
        ?.split(/\s+/)
        .splice(1, 2)
        .map((elem) => parseInt(elem)) ?? [0, 0],
  ],
})
const disk = Variable([0, 0], {
  poll: [
    1000,
    'df -B 1',
    (out) =>
      out
        .split('\n')
        .find((line) => line.includes('/dev/disk/by-label/ROOT'))
        ?.split(/\s+/)
        .splice(1, 2)
        .map((elem) => parseInt(elem)) ?? [0, 0],
  ],
})

function element(value, tooltip, color) {
  return Widget.CircularProgress({
    rounded: true,
    class_name: 'vitals-element',
    value: value,
    tooltip_text: tooltip,
    start_at: 0.75,
    css: `color: ${color}`,
  })
}

export default function Vitals() {
  return Widget.Box({
    class_name: 'panel-element',
    spacing: 5,
    children: [
      element(
        cpu.bind(),
        cpu.bind().as((c) => `${(c * 100).toFixed()}%`),
        '#8be9fd'
      ),
      element(
        ram.bind().as((r) => r[1] / r[0]),
        ram.bind().as((r) => `${(r[1] / 10 ** 9).toFixed(1)} / ${(r[0] / 10 ** 9).toFixed()} GB`),
        '#50fa7b'
      ),
      element(
        disk.bind().as((d) => d[1] / d[0]),
        disk.bind().as((d) => `${(d[1] / 10 ** 9).toFixed(1)} / ${(d[0] / 10 ** 9).toFixed()} GB`),
        '#ffb86c'
      ),
    ],
  })
}
