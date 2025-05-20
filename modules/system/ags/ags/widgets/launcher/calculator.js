import Launcher from './launcher.js'

const expression = Variable('')

function c(expression) {
  expression = expression.toLowerCase().replace('sqrt', 'Math.sqrt').replace('pi', 'Math.PI').replace('e', 'Math.E')
  if (eval(expression) === undefined || isNaN(eval(expression))) return '-'
  return eval(expression).toString()
}

function get_items() {
  return [
    {
      name: expression.bind().as((e) => c(e)),
      icon: 'edit-paste-symbolic',
      on_click: () => {
        if (c(expression.value) !== '-') Utils.execAsync(`wl-copy ${c(expression.value)}`)
      },
      filter: () => true,
    },
    {
      name: 'Open in calculator',
      icon: 'calculator',
      on_click: () => Utils.execAsync(`gnome-calculator -e "${expression.value}"`),
      filter: () => true,
    },
  ]
}

export default () => Launcher('calculator', get_items, 2, expression)
