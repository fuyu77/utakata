import { Controller } from '@hotwired/stimulus';

const PRESETS = {
  white: {
    background: '#ffffff',
    text: '#20242a',
  },
  washi: {
    background: '#f8f4ea',
    text: '#20242a',
  },
  sora: {
    background: '#e8f4fb',
    text: '#163547',
  },
  wakakusa: {
    background: '#edf6e8',
    text: '#1f3d2b',
  },
  sumi: {
    background: '#20242a',
    text: '#f4efe7',
  },
};

export default class extends Controller {
  static targets = ['backgroundColor', 'canvas', 'preset', 'textColor', 'author'];

  static values = {
    authorName: String,
    tanka: String,
    tankaText: String,
    url: String,
  };

  connect() {
    this.render();
  }

  selectPreset() {
    const preset = PRESETS[this.presetTarget.value] || PRESETS.white;

    this.backgroundColorTarget.value = preset.background;
    this.textColorTarget.value = preset.text;
    this.render();
  }

  render() {
    const canvas = this.canvasTarget;
    const context = canvas.getContext('2d');

    this.drawBackground(context);
    const tankaMetrics = this.drawTanka(context);
    this.drawMeta(context, tankaMetrics);
  }

  async download() {
    this.render();

    const blob = await this.createImageBlob();
    const file = new File([blob], `${this.tankaTextValue}.png`, { type: blob.type });
    const shareData = {
      files: [file],
      title: this.tankaTextValue,
      text: `${this.tankaTextValue}\n\n${this.urlValue}`,
      url: this.urlValue,
    };

    if (this.shouldUseNativeShare(shareData)) {
      try {
        await navigator.share(shareData);
        return;
      } catch (error) {
        if (error.name === 'AbortError') {
          return;
        }
      }
    }

    this.downloadBlob(blob, file.name);
  }

  shouldUseNativeShare(shareData) {
    if (!navigator.canShare?.(shareData)) {
      return false;
    }

    return window.matchMedia('(hover: none) and (pointer: coarse)').matches;
  }

  createImageBlob() {
    return new Promise((resolve, reject) => {
      this.canvasTarget.toBlob((blob) => {
        if (!blob) {
          reject(new Error('短歌画像の生成に失敗しました'));
          return;
        }

        resolve(blob);
      }, 'image/png');
    });
  }

  downloadBlob(blob, fileName) {
    const link = document.createElement('a');
    const objectUrl = URL.createObjectURL(blob);

    link.download = fileName;
    link.href = objectUrl;
    link.click();
    setTimeout(() => URL.revokeObjectURL(objectUrl), 0);
  }

  releaseModalFocus(event) {
    if (event.currentTarget.contains(document.activeElement)) {
      document.activeElement.blur();
    }
  }

  drawBackground(context) {
    const { width, height } = context.canvas;

    context.fillStyle = this.backgroundColorTarget.value;
    context.fillRect(0, 0, width, height);
  }

  drawTanka(context) {
    const units = this.parseTanka();
    const lineHeightRatio = 1.08;
    const verticalMargin = 100;
    const fontSize = this.calculateFontSize(context, units, verticalMargin, lineHeightRatio);
    const lineHeight = fontSize * lineHeightRatio;
    const maxRows =
      Math.floor((context.canvas.height - verticalMargin * 2 - fontSize) / lineHeight) + 1;
    const columnGap = 88;
    const positions = [];
    let column = 0;
    let row = 0;

    context.fillStyle = this.textColorTarget.value;
    context.font = `${fontSize}px serif`;
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    units.forEach((unit) => {
      if (unit.type === 'newline') {
        column += 1;
        row = 0;
        return;
      }

      if (row + unit.rowSpan > maxRows) {
        column += 1;
        row = 0;
      }

      positions.push({ ...unit, column, row });
      row += unit.rowSpan;
    });

    if (positions.length === 0) {
      return null;
    }

    const totalColumns = Math.max(...positions.map((position) => position.column)) + 1;
    const totalRows = Math.max(...positions.map((position) => position.row + position.rowSpan));
    const textHeight = (totalRows - 1) * lineHeight + fontSize;
    const firstRowY = (context.canvas.height - textHeight) / 2 + fontSize / 2;
    const firstColumnX = context.canvas.width / 2 + ((totalColumns - 1) * columnGap) / 2;
    const bottomY = firstRowY + (totalRows - 1) * lineHeight + fontSize / 2;

    positions.forEach((position) => {
      const x = firstColumnX - position.column * columnGap;
      const y = firstRowY + position.row * lineHeight;

      this.drawTankaUnit(context, position, x, y, fontSize, lineHeight);
    });

    return { bottomY };
  }

  calculateFontSize(context, units, verticalMargin, lineHeightRatio) {
    const maxRowsForSingleColumn = 30;
    const minFontSize = 38;
    const maxFontSize = 58;
    const availableHeight = context.canvas.height - verticalMargin * 2;
    const rowCount = Math.min(this.maxRowsWithoutWrapping(units), maxRowsForSingleColumn);
    const fittedFontSize = availableHeight / (1 + (rowCount - 1) * lineHeightRatio);

    return Math.max(minFontSize, Math.min(Math.floor(fittedFontSize), maxFontSize));
  }

  maxRowsWithoutWrapping(units) {
    let maxRows = 0;
    let rows = 0;

    units.forEach((unit) => {
      if (unit.type === 'newline') {
        maxRows = Math.max(maxRows, rows);
        rows = 0;
        return;
      }

      rows += unit.rowSpan;
    });

    return Math.max(maxRows, rows, 1);
  }

  parseTanka() {
    const template = document.createElement('template');
    template.innerHTML = this.tankaValue;

    return this.parseChildNodes(template.content.childNodes);
  }

  parseChildNodes(nodes) {
    return Array.from(nodes).flatMap((node) => this.parseNode(node));
  }

  parseNode(node) {
    if (node.nodeType === Node.TEXT_NODE) {
      return Array.from(node.textContent).map((character) => {
        if (character === '\n') {
          return { type: 'newline', text: character, rowSpan: 0 };
        }

        return { type: 'character', text: character, rowSpan: 1 };
      });
    }

    if (node.nodeType !== Node.ELEMENT_NODE) {
      return [];
    }

    if (node.tagName === 'RUBY') {
      const rt = node.querySelector('rt');
      const baseText = Array.from(node.childNodes)
        .filter((childNode) => !['RT', 'RP'].includes(childNode.tagName))
        .map((childNode) => childNode.textContent)
        .join('');

      return [
        {
          type: 'ruby',
          text: baseText,
          ruby: rt?.textContent || '',
          rowSpan: Math.max(Array.from(baseText).length, 1),
        },
      ];
    }

    if (node.classList.contains('tate')) {
      return [{ type: 'upright', text: node.textContent, rowSpan: 1 }];
    }

    return this.parseChildNodes(node.childNodes);
  }

  drawTankaUnit(context, unit, x, y, fontSize, lineHeight) {
    if (unit.type === 'ruby') {
      this.drawRuby(context, unit, x, y, fontSize, lineHeight);
      return;
    }

    if (unit.type === 'upright') {
      this.drawUpright(context, unit.text, x, y, fontSize);
      return;
    }

    this.drawVerticalCharacter(context, unit.text, x, y);
  }

  drawRuby(context, unit, x, y, fontSize, lineHeight) {
    const baseCharacters = Array.from(unit.text);
    const rubyCharacters = Array.from(unit.ruby);
    const rubyFontSize = Math.max(Math.round(fontSize * 0.34), 14);
    const rubyX = x + fontSize * 0.62;

    baseCharacters.forEach((character, index) => {
      context.font = `${fontSize}px serif`;
      this.drawVerticalCharacter(context, character, x, y + index * lineHeight);
    });

    if (rubyCharacters.length === 0) {
      return;
    }

    const baseHeight = (baseCharacters.length - 1) * lineHeight + fontSize;
    const baseCenterY = y + ((baseCharacters.length - 1) * lineHeight) / 2;
    const naturalRubyLineHeight = rubyFontSize * 0.95;
    const rubyLineHeight =
      rubyCharacters.length > 1
        ? Math.min(naturalRubyLineHeight, (baseHeight - rubyFontSize) / (rubyCharacters.length - 1))
        : naturalRubyLineHeight;
    const rubyHeight = (rubyCharacters.length - 1) * rubyLineHeight + rubyFontSize;
    const rubyY = baseCenterY - rubyHeight / 2 + rubyFontSize / 2;

    rubyCharacters.forEach((character, index) => {
      context.font = `${rubyFontSize}px serif`;
      this.drawVerticalCharacter(context, character, rubyX, rubyY + index * rubyLineHeight);
    });

    context.font = `${fontSize}px serif`;
  }

  drawVerticalCharacter(context, character, x, y) {
    if (!this.isSidewaysCharacter(character)) {
      context.fillText(character, x, y);
      return;
    }

    context.save();
    context.translate(x, y);
    context.rotate(Math.PI / 2);
    context.fillText(character, 0, 0);
    context.restore();
  }

  isSidewaysCharacter(character) {
    return /^[0-9A-Za-z]$/.test(character);
  }

  drawUpright(context, text, x, y, fontSize) {
    const targetWidth = fontSize;
    const measuredWidth = context.measureText(text).width || targetWidth;
    const scaleX = Math.min(targetWidth / measuredWidth, 1);

    context.save();
    context.translate(x, y);
    context.scale(scaleX, 1);
    context.fillText(text, 0, 0);
    context.restore();
  }

  drawMeta(context, tankaMetrics) {
    const x = 180;
    const fontSize = 30;
    const lineHeight = 38;
    const authorCharacters = Array.from(this.authorNameValue);
    const authorStartY =
      tankaMetrics === null
        ? 1300
        : tankaMetrics.bottomY -
          (Math.max(authorCharacters.length - 1, 0) * lineHeight + fontSize / 2);

    context.fillStyle = this.textColorTarget.value;
    context.font = `${fontSize}px serif`;
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    if (this.authorTarget.checked) {
      this.drawVerticalText(context, this.authorNameValue, x, authorStartY, lineHeight);
    }
  }

  drawVerticalText(context, text, x, y, lineHeight) {
    Array.from(text).forEach((character, index) => {
      this.drawVerticalCharacter(context, character, x, y + index * lineHeight);
    });
  }
}
