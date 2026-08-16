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

  it('初期表示で縦中横の記法をプレビューへ反映する', () => {
    expect(preview.innerHTML).toBe('春<span class="tate">一</span>');
  });

  it('入力プレビューでは許可していないHTMLタグと属性を反映しない', () => {
    input.value =
      '<ruby class="ruby" onclick="alert(1)">春<rt data-reading="はる">はる</rt></ruby><strong>危険</strong><tate style="color: red">12</tate><img src="invalid" onerror="alert(1)">';
    controller.previewPost();

    expect(preview.innerHTML).toBe(
      '<ruby>春<rt>はる</rt></ruby>危険<span class="tate">12</span>',
    );
    expect(preview.querySelector('strong, img')).toBeNull();
    expect(preview.querySelector('ruby').attributes).toHaveLength(0);
    expect(preview.querySelector('rt').attributes).toHaveLength(0);
    expect(
      preview.querySelector('[onclick], [onerror], [style], [data-reading]'),
    ).toBeNull();
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
