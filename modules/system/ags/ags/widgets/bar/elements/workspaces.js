const hyprland = await Service.import('hyprland')
export default function Workspaces() {
  const activeId = hyprland.bind('monitors').as((monitors) => monitors.find((m) => m.id === 0)?.activeWorkspace.id ?? 0)

  const workspaces = hyprland.bind('workspaces').as((ws) => ws
    .filter((w) => w.monitorID === 0 && !w.name.startsWith('special'))
    .map(({ id }) =>
      Widget.Button({
        class_name: activeId.as((i) => `${i === id ? 'focused' : ''}`),
        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      })
    ),
  );

  return Widget.Box({
    class_names: ['workspaces', 'panel-element'],
    spacing: 5,
    children: workspaces,
  })
}
