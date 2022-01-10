const TEXTBOX_SELECTOR_RHYME = "input[name='choices[][rhyme]']";
const CHOICE_RHYME_DATA_LIST_ID = 'list_choice_rhyme';

export const RhymeDataList = class {
  static setRhymeTextBoxChangeEvent(element) {
    element.addEventListener('change', (event) => {
      this.setChoiceRhimeDataList();
    });
  }

  /**
   * 母音の入力欄の値が変更された場合のイベントを設定する
   */
  static setAllRhymeTextBoxChangeEvent() {
    const rhymeTextBoxElementList = document.querySelectorAll(
      TEXTBOX_SELECTOR_RHYME
    );
    rhymeTextBoxElementList.forEach((rhymeTextBoxElement) => {
      rhymeTextBoxElement.addEventListener('change', (event) => {
        this.setChoiceRhimeDataList();
      });
    });
  }

  /**
   * 母音の入力欄の値をdatalistに設定する
   */
  static setChoiceRhimeDataList() {
    const rhymeTextBoxElementList = document.querySelectorAll(
      TEXTBOX_SELECTOR_RHYME
    );

    let selectBoxOptionHtml = '';
    let selectBoxValuRhymeList = [];

    rhymeTextBoxElementList.forEach((rhymeTextBoxElement) => {
      const optionValue = rhymeTextBoxElement.value;
      if (!optionValue) {
        return;
      }

      if (selectBoxValuRhymeList.includes(optionValue)) {
        return;
      }

      selectBoxValuRhymeList.push(optionValue);
    });

    selectBoxValuRhymeList.forEach((selectBoxValuRhyme) => {
      const optionHtml = `<option value="${selectBoxValuRhyme}">${selectBoxValuRhyme}</option>`;
      selectBoxOptionHtml += optionHtml;
    });

    const rhymeDatalistElement = document.getElementById(
      CHOICE_RHYME_DATA_LIST_ID
    );
    rhymeDatalistElement.innerHTML = selectBoxOptionHtml;
  }
};
