import { afterEach, beforeEach, describe, expect, it } from 'vitest';
import PostController from '../../../app/assets/javascripts/controllers/post_controller';
import { startStimulus } from '../helpers/stimulus';

describe('PostController', () => {
  let application;
  let controller;
  let input;
  let preview;

  beforeEach(async () => {
    document.body.innerHTML = `
      <div data-controller="post">
        <textarea data-post-target="input">春<tate>一</tate></textarea>
        <div data-post-target="preview"></div>
      </div>
    `;
    ({ application, controller } = await startStimulus('post', PostController));
    input = controller.inputTarget;
    preview = controller.previewTarget;
  });

  afterEach(() => application.stop());

  it('初期表示とプレビューでは許可した短歌記法だけを反映する', () => {
    expect(preview.innerHTML).toBe('春<span class="tate">一</span>');

    input.value =
      '<ruby>春<rt>はる</rt></ruby><script>危険</script><tate>1</tate>';
    controller.previewPost();

    expect(preview.innerHTML).toBe(
      '<ruby>春<rt>はる</rt></ruby>危険<span class="tate">1</span>',
    );
  });

  it('選択範囲をruby要素で囲み、ルビの入力位置へ移動する', () => {
    input.value = '春の歌';
    input.setSelectionRange(0, 1);

    controller.ruby();

    expect(input.value).toBe('<ruby>春<rt></rt></ruby>の歌');
    expect(preview.innerHTML).toBe('<ruby>春<rt></rt></ruby>の歌');
    expect(input.selectionStart).toBe(11);
    expect(document.activeElement).toBe(input);
  });

  it('選択範囲を縦中横の記法で囲んでプレビューする', () => {
    input.value = '令和8年';
    input.setSelectionRange(2, 3);

    controller.upright();

    expect(input.value).toBe('令和<tate>8</tate>年');
    expect(preview.innerHTML).toBe('令和<span class="tate">8</span>年');
    expect(input.selectionStart).toBe(16);
  });

  it('カーソル位置へ全角スペースを挿入する', () => {
    input.value = '春秋';
    input.setSelectionRange(1, 1);

    controller.space();

    expect(input.value).toBe('春　秋');
    expect(preview.innerHTML).toBe('春　秋');
    expect(input.selectionStart).toBe(2);
  });
});
