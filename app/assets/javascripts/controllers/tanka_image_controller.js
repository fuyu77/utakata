import { Controller } from '@hotwired/stimulus';

const TEMPLATES = {
  white: {
    background: '#ffffff',
    accent: '#d8dde3',
    text: '#20242a',
  },
  washi: {
    background: '#f8f4ea',
    accent: '#d7cbb8',
    text: '#20242a',
  },
  sora: {
    background: '#e8f4fb',
    accent: '#8fc5de',
    text: '#163547',
  },
  wakakusa: {
    background: '#edf6e8',
    accent: '#a7c79a',
    text: '#1f3d2b',
  },
  sumi: {
    background: '#20242a',
    accent: '#6f7680',
    text: '#f4efe7',
  },
};

export default class extends Controller {
  static targets = [
    'canvas',
    'template',
    'textColor',
    'author',
  ];

  static values = {
    authorName: String,
    tanka: String,
  };

  connect() {
    this.render();
  }

  selectTemplate() {
    const template = TEMPLATES[this.templateTarget.value] || TEMPLATES.washi;

    this.textColorTarget.value = template.text;
    this.render();
  }

  render() {
    const canvas = this.canvasTarget;
    const context = canvas.getContext('2d');
    const template = TEMPLATES[this.templateTarget.value] || TEMPLATES.washi;

    this.drawBackground(context, template);
    this.drawTanka(context);
    this.drawMeta(context, template);
  }

  download() {
    this.render();

    const link = document.createElement('a');
    link.download = 'utakata-tanka.png';
    link.href = this.canvasTarget.toDataURL('image/png');
    link.click();
  }

  drawBackground(context, template) {
    const { width, height } = context.canvas;

    context.fillStyle = template.background;
    context.fillRect(0, 0, width, height);

    context.strokeStyle = template.accent;
    context.lineWidth = 2;
    context.strokeRect(70, 70, width - 140, height - 140);

    context.globalAlpha = 0.08;
    for (let index = 0; index < 28; index += 1) {
      const y = 130 + index * 52;
      context.beginPath();
      context.moveTo(120, y);
      context.lineTo(width - 120, y + 18);
      context.stroke();
    }
    context.globalAlpha = 1;
  }

  drawTanka(context) {
    const units = this.parseTanka();
    const tankaLength = units.reduce((length, unit) => length + unit.text.length, 0);
    const maxRows = 19;
    const fontSize = tankaLength > 55 ? 42 : 48;
    const lineHeight = fontSize * 1.22;
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
      return;
    }

    const totalColumns =
      Math.max(...positions.map((position) => position.column)) + 1;
    const firstColumnX =
      context.canvas.width / 2 + ((totalColumns - 1) * columnGap) / 2;

    positions.forEach((position) => {
      const x = firstColumnX - position.column * columnGap;
      const y = 250 + position.row * lineHeight;

      this.drawTankaUnit(context, position, x, y, fontSize, lineHeight);
    });
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

    context.fillText(unit.text, x, y);
  }

  drawRuby(context, unit, x, y, fontSize, lineHeight) {
    const baseCharacters = Array.from(unit.text);
    const rubyCharacters = Array.from(unit.ruby);
    const rubyFontSize = Math.max(Math.round(fontSize * 0.34), 14);
    const rubyX = x + fontSize * 0.62;

    baseCharacters.forEach((character, index) => {
      context.font = `${fontSize}px serif`;
      context.fillText(character, x, y + index * lineHeight);
    });

    if (rubyCharacters.length === 0) {
      return;
    }

    const baseHeight = (baseCharacters.length - 1) * lineHeight;
    const rubyLineHeight =
      baseCharacters.length > 1
        ? baseHeight / Math.max(rubyCharacters.length - 1, 1)
        : rubyFontSize * 0.9;
    const rubyY =
      y + baseHeight / 2 - ((rubyCharacters.length - 1) * rubyLineHeight) / 2;

    rubyCharacters.forEach((character, index) => {
      context.font = `${rubyFontSize}px serif`;
      context.fillText(character, rubyX, rubyY + index * rubyLineHeight);
    });

    context.font = `${fontSize}px serif`;
  }

  drawUpright(context, text, x, y, fontSize) {
    const uprightFontSize = Math.max(Math.round(fontSize * 0.72), 20);

    context.font = `${uprightFontSize}px serif`;
    context.fillText(text, x, y);
    context.font = `${fontSize}px serif`;
  }

  drawMeta(context) {
    const x = 180;

    context.fillStyle = this.textColorTarget.value;
    context.font = '30px serif';
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    if (this.authorTarget.checked) {
      this.drawVerticalText(context, this.authorNameValue, x, 1300, 38);
    }
  }

  drawVerticalText(context, text, x, y, lineHeight) {
    Array.from(text).forEach((character, index) => {
      context.fillText(character, x, y + index * lineHeight);
    });
  }
}
