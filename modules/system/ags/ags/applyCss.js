export default () => {
  try {
    Utils.exec(`sassc ${App.configDir}/scss/style.scss /tmp/style.css`)
    App.resetCss()
    App.applyCss('/tmp/style.css')
  } catch (error) {
    if (error instanceof Error) console.error(error.message)
    if (typeof error === 'string') console.error(error)
  }
}
