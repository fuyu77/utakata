import { Controller } from '@hotwired/stimulus';

const TEMPLATES = {
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
    'site',
  ];

  static values = {
    authorName: String,
    siteName: String,
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
    const characters = Array.from(this.tankaValue);
    const maxRows = 19;
    const fontSize = characters.length > 55 ? 42 : 48;
    const lineHeight = fontSize * 1.22;
    const columnGap = 88;
    let column = 0;
    let row = 0;

    context.fillStyle = this.textColorTarget.value;
    context.font = `${fontSize}px serif`;
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    characters.forEach((character) => {
      if (character === '\n' || row >= maxRows) {
        column += 1;
        row = 0;
      }

      if (character === '\n') {
        return;
      }

      const x = context.canvas.width - 250 - column * columnGap;
      const y = 250 + row * lineHeight;

      context.fillText(character, x, y);
      row += 1;
    });
  }

  drawMeta(context, template) {
    const x = 180;

    context.fillStyle = this.textColorTarget.value;
    context.font = '30px serif';
    context.textAlign = 'center';
    context.textBaseline = 'middle';

    if (this.siteTarget.checked) {
      context.fillStyle = template.accent;
      this.drawVerticalText(context, this.siteNameValue, x, 1080, 34);
    }

    if (this.authorTarget.checked) {
      context.fillStyle = this.textColorTarget.value;
      this.drawVerticalText(context, this.authorNameValue, x, 1300, 38);
    }
  }

  drawVerticalText(context, text, x, y, lineHeight) {
    Array.from(text).forEach((character, index) => {
      context.fillText(character, x, y + index * lineHeight);
    });
  }
}
