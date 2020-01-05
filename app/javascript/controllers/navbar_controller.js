import { Controller } from "stimulus"

export default class extends Controller {
  prevent(e) {
    e.stopPropagation()
  }
}
