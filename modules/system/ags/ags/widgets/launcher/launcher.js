export default function Launcher(name, get_items, height = 5, filter) {
  let items = get_items('').map(Item)

  const entry = Widget.Entry({
    class_name: 'launcher-entry',
    on_accept: () => {
      const results = items.filter((item) => item.visible)
      if (results[0]) {
        App.toggleWindow(`${name}-launcher`)
        results[0].attribute.item.on_click()
      }
    },
    on_change: ({ text }) => {
      if (filter) filter.setValue(text)
      items.forEach((item) => {
        item.visible = item.attribute.item.filter(text ?? '')
      })
    },
  })

  const item_list = Widget.Box({
    vertical: true,
    spacing: 5,
    children: items,
  })
  function Item(item) {
    return Widget.Button({
      class_name: 'item',
      on_clicked: () => {
        App.closeWindow(`${name}-launcher`)
        item.on_click()
      },
      attribute: { item },
      child: Widget.Box({
        spacing: 5,
        children: [
          Widget.Icon({
            icon: item.icon || '',
            size: item.icon.includes('symbolic') ? 20 : 30,
            css: item.icon.includes('symbolic') ? 'margin: 0 5px' : '',
          }),
          Widget.Label({
            label: item.name,
            css: 'min-height: 30px',
            xalign: 0,
            vpack: 'center',
            truncate: 'end',
          }),
        ],
      }),
    })
  }

  return Widget.Window({
    name: `${name}-launcher`,
    monitor: 0,
    class_name: 'launcher',
    setup: (self) =>
      self.keybind('Escape', () => {
        App.closeWindow(`${name}-launcher`)
      }),
    visible: false,
    keymode: 'exclusive',
    child: Widget.Box({
      vertical: true,
      children: [
        entry,
        Widget.Scrollable({
          class_name: 'list',
          css: `min-height: ${height * 37 - 5}px`,
          vscroll: 'external',
          hscroll: 'never',
          child: item_list,
        }),
      ],
      setup: (self) =>
        self.hook(App, (_, windowName, visible) => {
          if (windowName !== `${name}-launcher`) return

          if (visible) {
            items = get_items('').map(Item)
            item_list.children = items
            entry.text = ''
            entry.grab_focus()
          }
        }),
    }),
  })
}
