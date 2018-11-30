(function (ActiveAdmin) {
  $(document).ready(function () {
    $('a.open-simple-modal').click(function (e) {
      e.stopPropagation();
      e.preventDefault();

      var modalText = $(this).data('modal-text');
      var modalTitle = $(this).data('modal-title');

      var html = `<div title='${modalTitle}' style="padding: 10px;"><p>${modalText}</p></div>`;

      $(html).dialog({
        appendTo: "body",
        closeOnEscape: true,
        closeText: null,
        width: 'auto',
        maxWidth: 800,
        buttons: {
          OK() {
            $(this).dialog('close').remove();
          }
        },
        open() {
          // quick but dirty remove of close button, dont want to change css
          $(this).parent().find('.ui-dialog-titlebar-close').remove();
        }
      });
    });
  });
})(window.ActiveAdmin);
