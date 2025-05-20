const systemTray = await Service.import('systemtray')

export default function SysTray() {
  const items = systemTray.bind('items').as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind('icon'), size: 20 }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind('tooltip_markup'),
      })
    )
  )

  return Widget.Box({
    class_name: 'panel-element',
    children: items,
  })
}
