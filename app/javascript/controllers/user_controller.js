import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['submit']

  submit () {
    this.submitTarget.click()
  }
}
