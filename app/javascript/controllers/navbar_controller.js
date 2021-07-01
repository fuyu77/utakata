import { Controller } from 'stimulus'

export default class extends Controller {
  preventBootstarapNativeEvent(e) {
    e.stopPropagation()
  }
}
