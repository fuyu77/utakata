import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "post" ]

  select(e) {
    e.currentTarget.childNodes[0].classList.toggle("hidden")
  }
}
