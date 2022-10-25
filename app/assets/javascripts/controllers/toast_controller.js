import { Controller } from '@hotwired/stimulus'
import Toast from 'bootstrap/js/dist/toast'

export default class extends Controller {
  connect() {
    const toasts = Array.from(document.querySelectorAll('div.toast:not(.show):not(.hide)'))
    if (toasts) {
      toasts.forEach((toastNode) => {
        const toast = new Toast(toastNode, { delay: 1500 })
        toast.show()
      })
    }
  }
}
