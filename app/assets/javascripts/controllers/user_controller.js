import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['submit'];

  submit() {
    this.submitTarget.click();
  }
}
