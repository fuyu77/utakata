import { beforeEach, describe, expect, it } from 'vitest';
import '../../app/assets/javascripts/analytics';

function visit(url) {
  document.dispatchEvent(new CustomEvent('turbo:load', { detail: { url } }));
}

describe('Google Analytics', () => {
  beforeEach(() => {
    delete window.dataLayer;
  });

  it('Googleタグが処理するArguments形式でコマンドをキューに入れる', () => {
    visit('https://utakatanka.jp/');

    expect(window.dataLayer).toHaveLength(3);
    for (const command of window.dataLayer) {
      expect(Object.prototype.toString.call(command)).toBe(
        '[object Arguments]',
      );
    }
    expect(Array.from(window.dataLayer[0])).toEqual(['js', expect.any(Date)]);
  });

  it('自動送信を無効にして初回表示とTurbo遷移のページビューを送る', () => {
    const urls = ['https://utakatanka.jp/', 'https://utakatanka.jp/posts/1'];

    for (const url of urls) visit(url);

    const commands = window.dataLayer.map((command) => Array.from(command));
    const configurations = commands.filter(([command]) => command === 'config');
    expect(configurations).toHaveLength(2);
    for (const [index, url] of urls.entries()) {
      expect(configurations[index]).toEqual([
        'config',
        'G-PB35HE8YLS',
        { page_location: url, send_page_view: false },
      ]);
    }
    expect(commands.filter(([command]) => command === 'event')).toEqual(
      urls.map((url) => [
        'event',
        'page_view',
        { page_location: url, send_to: 'G-PB35HE8YLS' },
      ]),
    );
  });

  it('既存のdataLayerを保持する', () => {
    const existingCommand = { event: 'existing' };
    const dataLayer = [existingCommand];
    window.dataLayer = dataLayer;

    visit('https://utakatanka.jp/');

    expect(window.dataLayer).toBe(dataLayer);
    expect(window.dataLayer[0]).toBe(existingCommand);
    expect(window.dataLayer).toHaveLength(4);
  });
});
