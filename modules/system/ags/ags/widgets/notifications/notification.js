function NotificationIcon({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Box({
      css: `background-image: url("${image}");` + 'background-size: contain;' + 'background-repeat: no-repeat;' + 'background-position: center;',
    })
  }

  let icon = 'dialog-information-symbolic'
  if (Utils.lookUpIcon(app_icon)) icon = app_icon

  if (app_entry && Utils.lookUpIcon(app_entry)) icon = app_entry

  return Widget.Box({
    child: Widget.Icon({
      size: 40,
      icon,
    }),
  })
}

export default function Notification(n) {
  const icon = Widget.Box({
    vpack: 'center',
    class_name: 'icon',
    child: NotificationIcon(n),
  })

  const title = Widget.Label({
    class_name: 'title',
    xalign: 0,
    justification: 'left',
    hexpand: true,
    max_width_chars: 24,
    truncate: 'end',
    wrap: true,
    label: n.summary,
    use_markup: true,
  })

  const body = Widget.Label({
    class_name: 'body',
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: 'left',
    label: n.body,
    wrap: true,
  })

  const actions = Widget.Box({
    class_name: 'actions',
    spacing: 10,
    visible: n.bind('actions').as((actions) => actions.length > 0),
    children: n.actions.map(({ id, label }) =>
      Widget.Button({
        class_name: 'action-button',
        on_clicked: () => {
          n.invoke(id)
          n.dismiss()
        },
        hexpand: true,
        child: Widget.Label(label),
      })
    ),
  })

  return Widget.EventBox(
    {
      attribute: { id: n.id },
      on_primary_click: n.dismiss,
    },
    Widget.Box({
      class_name: `notification ${n.urgency}`,
      vertical: true,
      children: [
        Widget.Box({
          spacing: 10,
          children: [
            icon,
            Widget.Box({
              vertical: true,
              spacing: 5,
              children: [title, body],
            }),
            Widget.Button({
              class_name: 'close-button',
              vpack: 'start',
              on_clicked: n.close,
              child: Widget.Icon({ icon: 'window-close-symbolic' }),
            }),
          ],
        }),
        actions,
      ],
    })
  )
}
