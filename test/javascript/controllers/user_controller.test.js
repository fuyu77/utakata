import { afterEach, describe, expect, it, vi } from 'vitest';
import UserController from '../../../app/assets/javascripts/controllers/user_controller';
import { startStimulus } from '../helpers/stimulus';

describe('UserController', () => {
  let application;

  afterEach(() => application?.stop());

  it('表示用の操作から送信ボタンをクリックする', async () => {
    document.body.innerHTML = `
      <div data-controller="user">
        <button data-user-target="submit" type="button">送信</button>
      </div>
    `;
    const result = await startStimulus('user', UserController);
    application = result.application;
    const click = vi.spyOn(result.controller.submitTarget, 'click');

    result.controller.submit();

    expect(click).toHaveBeenCalledOnce();
  });
});
