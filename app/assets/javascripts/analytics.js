document.addEventListener('turbo:load', (event) => {
  window.dataLayer ||= [];
  function gtag() {
    // biome-ignore lint/complexity/noArguments: Googleタグは配列ではなくArguments形式でコマンドを受け取る
    window.dataLayer.push(arguments);
  }

  gtag('js', new Date());

  gtag('config', 'G-PB35HE8YLS', {
    page_location: event.detail.url,
    send_page_view: false,
  });
  gtag('event', 'page_view', {
    page_location: event.detail.url,
    send_to: 'G-PB35HE8YLS',
  });
});
