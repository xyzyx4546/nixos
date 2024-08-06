import Logo from './elements/logo.js'
import SysTray from './elements/systray.js'
import Workspaces from './elements/workspaces.js'

import Vitals from './elements/vitals.js'
import Indicators from './elements/indicators.js'
import Power from './elements/power.js'

import { Time, Date } from './elements/date.js'

function Left() {
  return Widget.CenterBox({
    start_widget: Widget.Box({
      children: [Logo(), Widget.Separator(), SysTray(), Widget.Separator(), Workspaces()],
    }),
    end_widget: Time(),
  })
}

function Right() {
  return Widget.CenterBox({
    startWidget: Date(),
    end_widget: Widget.Box({
      hpack: 'end',
      children: [Vitals(), Widget.Separator(), Indicators(), Widget.Separator(), Power()],
    }),
  })
}

export default function Bar() {
  return Widget.Window({
    name: 'bar',
    class_name: 'bar',
    exclusivity: 'exclusive',
    monitor: 0,
    anchor: ['top', 'left', 'right'],
    child: Widget.CenterBox({
      class_name: 'panel',
      start_widget: Left(),
      center_widget: Widget.Separator(),
      end_widget: Right(),
    }),
  })
}
