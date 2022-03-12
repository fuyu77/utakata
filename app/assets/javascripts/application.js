// Entry point for the build script in your package.json

import '../stylesheets/application.scss'
import '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'
import { definitionsFromContext } from '@hotwired/stimulus-webpack-helpers'
import '@popperjs/core'
import 'bootstrap/js/dist/dropdown'
import 'bootstrap/js/dist/tab'
import Toast from 'bootstrap/js/dist/toast'
import 'bootstrap-icons/font/bootstrap-icons.css'

document.addEventListener('turbo:load', () => {
  const toasts = Array.from(document.querySelectorAll('.toast'))
  if (toasts) {
    toasts.forEach((toastNode) => {
      const toast = new Toast(toastNode, { delay: 1500 })
      toast.show()
    })
  }
})

window.Stimulus = Application.start()
const context = require.context('./controllers', true, /\.js$/)
window.Stimulus.load(definitionsFromContext(context))
