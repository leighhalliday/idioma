window.InlinePhraseUpdater = class InlinePhraseUpdater
  constructor: () ->
    # attributes
    @phraseInputs = $(".i18n_value")

    # events
    @phraseInputs.on "focus", (e) => @setOriginalValue(e)
    @phraseInputs.on "blur", (e) => @updateIfChanged(e)

    # init

  setOriginalValue: (e) =>
    phraseInput = $(e.target)
    phraseInput.data("original", phraseInput.val())

  updateIfChanged: (e) =>
    phraseInput = $(e.target)
    if phraseInput.data("original") != phraseInput.val()
      @updateStatus(phraseInput, "status-working")
      $.ajax(
        type: "PUT"
        url: phraseInput.data("url")
        dataType: "json"
        data:
          phrase:
            i18n_value: phraseInput.val()
      ).done((data) =>
        @updateStatus(phraseInput, "status-success")
      ).fail((data) =>
        @updateStatus(phraseInput, "status-error")
      )

  updateStatus: (input, status) ->
    input.removeClass("status-success").removeClass("status-error").removeClass("status-working")
    input.addClass(status)