import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const { show, Toast } = vi.hoisted(() => ({
  show: vi.fn(),
  Toast: vi.fn(),
}));

vi.mock('bootstrap/js/dist/toast', () => ({
  default: Toast,
}));

import ToastController from '../../../app/assets/javascripts/controllers/toast_controller';
import { startStimulus } from '../helpers/stimulus';

describe('ToastController', () => {
  let application;

  beforeEach(() => {
    Toast.mockImplementation(function MockToast() {
      return { show };
    });
  });

  afterEach(() => {
    application?.stop();
    vi.clearAllMocks();
  });

  it('未表示のトーストだけを一定時間表示する', async () => {
    document.body.innerHTML = `
      <div data-controller="toast"></div>
      <div id="new" class="toast"></div>
      <div class="toast show"></div>
      <div class="toast hide"></div>
    `;

    ({ application } = await startStimulus('toast', ToastController));

    expect(Toast).toHaveBeenCalledOnce();
    expect(Toast).toHaveBeenCalledWith(document.querySelector('#new'), {
      delay: 1500,
    });
    expect(show).toHaveBeenCalledOnce();
  });
});
