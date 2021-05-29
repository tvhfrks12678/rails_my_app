const TEXTBOX_SELECTOR_RHYME = "input[name='rhyme[][content]']";
const SELECTBOX_SELECTOR_CHOICE_RHYME = 'select[name="choice[][rhyme]"]';
const SELECTBOX_OPTION_INIT_ITEM = '韻なし';
const SELECTBOX_FADE_IN_TIME = '1500';

window.addEventListener('DOMContentLoaded', (event) => {
  initializeQuizForm();
});

const initializeQuizForm = () => {
  setRhymeTextBoxChangeEvent();
  setSelectBoxValueChoiceRhime();
  setChoiceFormDragAndDrop();
};

/**
 * 母音の入力欄の値が変更された場合のイベントを設定する
 */
const setRhymeTextBoxChangeEvent = () => {
  const rhymeTextBoxElementList = document.querySelectorAll(
    TEXTBOX_SELECTOR_RHYME
  );

  rhymeTextBoxElementList.forEach((rhymeTextBoxElement) => {
    rhymeTextBoxElement.addEventListener('change', (event) => {
      setSelectBoxValueChoiceRhime();
    });
  });
};

/**
 * 母音の入力欄の値を選択肢の母音のセレクトボックスに設定する
 */
const setSelectBoxValueChoiceRhime = () => {
  const rhymeTextBoxElementList = document.querySelectorAll(
    TEXTBOX_SELECTOR_RHYME
  );

  let selectBoxOptionHtml = `<option value>${SELECTBOX_OPTION_INIT_ITEM}</option>`;
  let SelectBoxValurhymeeList = [];

  rhymeTextBoxElementList.forEach((rhymeTextBoxElement) => {
    optionValue = rhymeTextBoxElement.value;
    if (!optionValue) {
      return;
    }
    SelectBoxValurhymeeList.push(optionValue);
    const optionHtml = `<option value="${optionValue}">${optionValue}</option>`;
    selectBoxOptionHtml += optionHtml;
  });

  const selectBoxChoiceRhymeElementList = document.querySelectorAll(
    SELECTBOX_SELECTOR_CHOICE_RHYME
  );

  selectBoxChoiceRhymeElementList.forEach((selectBoxChoiceRhymeElement) => {
    const selectValue = selectBoxChoiceRhymeElement.value;
    selectBoxChoiceRhymeElement.innerHTML = selectBoxOptionHtml;
    if (SelectBoxValurhymeeList.includes(selectValue)) {
      selectBoxChoiceRhymeElement.value = selectValue;
    }
    selectBoxChoiceRhymeElement.animate(
      [{ opacity: '0' }, { opacity: '1' }],
      SELECTBOX_FADE_IN_TIME
    );
  });
};

/**
 * 選択肢の入力欄をドラッグ＆ドロップできる設定にする
 */
const setChoiceFormDragAndDrop = () => {
  document.querySelectorAll('.list_choice li').forEach((elm) => {
    elm.ondragstart = function () {
      event.dataTransfer.setData('text/plain', event.target.id);
      this.style.opacity = '0.4';
    };
    elm.ondragover = function () {
      event.preventDefault();
      this.style.borderTop = '2px solid #0074D9';
    };
    elm.ondragleave = function () {
      this.style.borderTop = '';
    };
    elm.ondrop = function () {
      event.preventDefault();
      let id = event.dataTransfer.getData('text/plain');
      let elm_drag = document.getElementById(id);
      this.parentNode.insertBefore(elm_drag, this);
      this.style.borderTop = '';
      elm_drag.style.opacity = '1';
    };
  });
};
