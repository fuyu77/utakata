import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import TankaImageController from '../../../app/assets/javascripts/controllers/tanka_image_controller';
import { startStimulus } from '../helpers/stimulus';

function createCanvasContext() {
  return {
    fillRect: vi.fn(),
    fillText: vi.fn(),
    measureText: vi.fn(() => ({ width: 100 })),
    restore: vi.fn(),
    rotate: vi.fn(),
    save: vi.fn(),
    scale: vi.fn(),
    translate: vi.fn(),
  };
}

describe('TankaImageController', () => {
  let application;
  let canvas;
  let context;
  let controller;

  beforeEach(async () => {
    context = createCanvasContext();
    vi.spyOn(HTMLCanvasElement.prototype, 'getContext').mockImplementation(
      function getContext() {
        context.canvas = this;
        return context;
      },
    );
    vi.spyOn(HTMLCanvasElement.prototype, 'toBlob').mockImplementation(
      (callback) => callback(new Blob(['image'], { type: 'image/png' })),
    );
    Object.defineProperty(window, 'matchMedia', {
      configurable: true,
      value: vi.fn(() => ({ matches: false })),
    });
    Object.defineProperty(navigator, 'canShare', {
      configurable: true,
      value: vi.fn(() => false),
    });
    Object.defineProperty(navigator, 'share', {
      configurable: true,
      value: vi.fn(),
    });
    Object.defineProperty(URL, 'createObjectURL', {
      configurable: true,
      value: vi.fn(() => 'blob:image'),
    });
    Object.defineProperty(URL, 'revokeObjectURL', {
      configurable: true,
      value: vi.fn(),
    });

    document.body.innerHTML = `
      <div
        id="tanka-image"
        data-controller="tanka-image"
        data-tanka-image-author-name-value="詠み人"
        data-tanka-image-tanka-text-value="春の歌"
        data-tanka-image-url-value="https://example.com/posts/1"
      >
        <input data-tanka-image-target="backgroundColor" value="#ffffff">
        <input data-tanka-image-target="textColor" value="#20242a">
        <select data-tanka-image-target="preset">
          <option value="sora">空</option>
          <option value="unknown">不明</option>
        </select>
        <input data-tanka-image-target="author" type="checkbox" checked>
        <canvas data-tanka-image-target="canvas" width="1080" height="1440"></canvas>
      </div>
    `;
    document
      .querySelector('#tanka-image')
      .setAttribute(
        'data-tanka-image-tanka-value',
        '春A\n<ruby>霞<rt>かすみ</rt></ruby><span class="tate">12</span>',
      );

    ({ application, controller } = await startStimulus(
      'tanka-image',
      TankaImageController,
    ));
    canvas = controller.canvasTarget;
  });

  afterEach(() => {
    application.stop();
    vi.useRealTimers();
    vi.restoreAllMocks();
  });

  it('接続時に背景・短歌・作者をキャンバスへ描画する', () => {
    expect(context.fillRect).toHaveBeenCalledWith(0, 0, 1080, 1440);
    expect(context.fillText).toHaveBeenCalledWith(
      '春',
      expect.any(Number),
      expect.any(Number),
    );
    expect(context.fillText).toHaveBeenCalledWith(
      '詠',
      180,
      expect.any(Number),
    );
    expect(context.rotate).toHaveBeenCalledWith(Math.PI / 2);
    expect(context.scale).toHaveBeenCalled();
  });

  it('プリセットの配色を反映し、不明な値は白背景へ戻す', () => {
    const render = vi.spyOn(controller, 'render');

    controller.presetTarget.value = 'sora';
    controller.selectPreset();
    expect(controller.backgroundColorTarget.value).toBe('#e8f4fb');
    expect(controller.textColorTarget.value).toBe('#163547');

    controller.presetTarget.value = 'unknown';
    controller.selectPreset();
    expect(controller.backgroundColorTarget.value).toBe('#ffffff');
    expect(controller.textColorTarget.value).toBe('#20242a');
    expect(render).toHaveBeenCalledTimes(2);
  });

  it('短歌のHTMLを描画単位へ変換する', () => {
    controller.tankaValue =
      '春\n<ruby>霞<rp>(</rp><rt>かすみ</rt><rp>)</rp></ruby><span class="tate">12</span><em>秋</em><!-- 無視 -->';

    expect(controller.parseTanka()).toEqual([
      { type: 'character', text: '春', rowSpan: 1 },
      { type: 'newline', text: '\n', rowSpan: 0 },
      { type: 'ruby', text: '霞', ruby: 'かすみ', rowSpan: 1 },
      { type: 'upright', text: '12', rowSpan: 1 },
      { type: 'character', text: '秋', rowSpan: 1 },
    ]);
  });

  it('行数に合わせてフォントサイズを範囲内に収める', () => {
    expect(controller.maxRowsWithoutWrapping([])).toBe(1);
    expect(
      controller.maxRowsWithoutWrapping([
        { type: 'character', rowSpan: 2 },
        { type: 'newline', rowSpan: 0 },
        { type: 'character', rowSpan: 4 },
      ]),
    ).toBe(4);
    expect(controller.calculateFontSize(context, [], 100, 1.08)).toBe(58);
    expect(
      controller.calculateFontSize(
        context,
        [{ type: 'character', rowSpan: 100 }],
        100,
        1.08,
      ),
    ).toBe(38);
  });

  it('描画対象が空なら短歌の位置情報を返さない', () => {
    vi.spyOn(controller, 'parseTanka').mockReturnValue([]);

    expect(controller.drawTanka(context)).toBeNull();
  });

  it('文字種ごとに縦書き、横倒し、縦中横を描き分ける', () => {
    controller.drawVerticalCharacter(context, '春', 10, 20);
    expect(context.fillText).toHaveBeenCalledWith('春', 10, 20);

    controller.drawVerticalCharacter(context, 'A', 30, 40);
    expect(context.translate).toHaveBeenCalledWith(30, 40);
    expect(context.rotate).toHaveBeenCalledWith(Math.PI / 2);
    expect(controller.isSidewaysCharacter('9')).toBe(true);
    expect(controller.isSidewaysCharacter('春')).toBe(false);

    controller.drawUpright(context, '12', 50, 60, 40);
    expect(context.scale).toHaveBeenCalledWith(0.4, 1);
    expect(context.fillText).toHaveBeenCalledWith('12', 0, 0);
  });

  it('ルビの有無に応じて本文と読みを描画する', () => {
    const draw = vi.spyOn(controller, 'drawVerticalCharacter');

    controller.drawRuby(
      context,
      { text: '春日', ruby: 'かすが' },
      100,
      200,
      40,
      44,
    );
    expect(draw).toHaveBeenCalledWith(context, '春', 100, 200);
    expect(draw).toHaveBeenCalledWith(context, '日', 100, 244);
    expect(draw).toHaveBeenCalledWith(
      context,
      'か',
      expect.any(Number),
      expect.any(Number),
    );

    draw.mockClear();
    controller.drawRuby(context, { text: '春', ruby: '' }, 100, 200, 40, 44);
    expect(draw).toHaveBeenCalledOnce();
  });

  it('作者表示の指定に従ってメタ情報を描画する', () => {
    const draw = vi.spyOn(controller, 'drawVerticalText');

    controller.authorTarget.checked = false;
    controller.drawMeta(context, null);
    expect(draw).not.toHaveBeenCalled();

    controller.authorTarget.checked = true;
    controller.drawMeta(context, { bottomY: 900 });
    expect(draw).toHaveBeenCalledWith(
      context,
      '詠み人',
      180,
      expect.any(Number),
      38,
    );
  });

  it('共有可能なタッチ端末では生成画像をネイティブ共有する', async () => {
    const blob = new Blob(['image'], { type: 'image/png' });
    vi.spyOn(controller, 'createImageBlob').mockResolvedValue(blob);
    vi.spyOn(controller, 'shouldUseNativeShare').mockReturnValue(true);
    const downloadBlob = vi.spyOn(controller, 'downloadBlob');
    navigator.share.mockResolvedValue();

    await controller.download();

    expect(navigator.share).toHaveBeenCalledWith({
      files: [expect.any(File)],
      title: '春の歌',
      text: '春の歌\n\nhttps://example.com/posts/1',
      url: 'https://example.com/posts/1',
    });
    expect(downloadBlob).not.toHaveBeenCalled();
  });

  it('共有非対応または共有失敗時は画像をダウンロードする', async () => {
    const blob = new Blob(['image'], { type: 'image/png' });
    vi.spyOn(controller, 'createImageBlob').mockResolvedValue(blob);
    vi.spyOn(controller, 'shouldUseNativeShare').mockReturnValue(false);
    const downloadBlob = vi
      .spyOn(controller, 'downloadBlob')
      .mockImplementation(() => {});

    await controller.download();
    expect(downloadBlob).toHaveBeenCalledWith(blob, '春の歌.png');

    controller.shouldUseNativeShare.mockReturnValue(true);
    navigator.share.mockRejectedValue(new Error('共有失敗'));
    await controller.download();
    expect(downloadBlob).toHaveBeenCalledTimes(2);
  });

  it('ユーザーが共有を中止した場合はダウンロードしない', async () => {
    vi.spyOn(controller, 'createImageBlob').mockResolvedValue(
      new Blob(['image'], { type: 'image/png' }),
    );
    vi.spyOn(controller, 'shouldUseNativeShare').mockReturnValue(true);
    const downloadBlob = vi.spyOn(controller, 'downloadBlob');
    navigator.share.mockRejectedValue(new DOMException('', 'AbortError'));

    await controller.download();

    expect(downloadBlob).not.toHaveBeenCalled();
  });

  it('端末の共有能力と入力方式からネイティブ共有を判定する', () => {
    const shareData = { files: [] };
    navigator.canShare.mockReturnValue(true);
    window.matchMedia.mockReturnValue({ matches: true });
    expect(controller.shouldUseNativeShare(shareData)).toBe(true);

    navigator.canShare.mockReturnValue(false);
    expect(controller.shouldUseNativeShare(shareData)).toBe(false);
  });

  it('canvasからPNG Blobを生成し、失敗時は例外にする', async () => {
    await expect(controller.createImageBlob()).resolves.toEqual(
      expect.objectContaining({ type: 'image/png' }),
    );
    expect(canvas.toBlob).toHaveBeenCalledWith(
      expect.any(Function),
      'image/png',
    );

    canvas.toBlob.mockImplementationOnce((callback) => callback(null));
    await expect(controller.createImageBlob()).rejects.toThrow(
      '短歌画像の生成に失敗しました',
    );
  });

  it('Blobのダウンロード後にオブジェクトURLを解放する', () => {
    vi.useFakeTimers();
    const click = vi
      .spyOn(HTMLAnchorElement.prototype, 'click')
      .mockImplementation(() => {});

    controller.downloadBlob(new Blob(['image']), '春.png');

    expect(click).toHaveBeenCalledOnce();
    expect(URL.createObjectURL).toHaveBeenCalledOnce();
    vi.runAllTimers();
    expect(URL.revokeObjectURL).toHaveBeenCalledWith('blob:image');
  });

  it('モーダル内にフォーカスがあれば閉じる前に解除する', () => {
    const modal = document.createElement('div');
    const button = document.createElement('button');
    modal.append(button);
    document.body.append(modal);
    button.focus();
    const blur = vi.spyOn(button, 'blur');

    controller.releaseModalFocus({ currentTarget: modal });

    expect(blur).toHaveBeenCalledOnce();
  });
});
