const battery = await Service.import('battery')

function checkBattery(percentage, isCharging, isCritical) {
  if (percentage < 0) return
  if (percentage <= 20 && !isCritical.value && !isCharging) {
    isCritical.setValue(true)
    Utils.notify(`Battery Low (${percentage}%)`, 'Connect to power as soon as possible', 'battery-empty-symbolic')
  } else if ((percentage > 20 || isCharging) && isCritical.value) {
    isCritical.setValue(false)
  }
}

export default function BatteryNotification() {
  const isCritical = Variable(false)
  checkBattery(battery.percent, battery.charging, isCritical)

  battery.connect('changed', () => {
    checkBattery(battery.percent, battery.charging, isCritical)
  })
}
