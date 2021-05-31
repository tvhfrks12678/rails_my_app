window.addEventListener('DOMContentLoaded', (event) => {
  initializeQuizForm();
});

const initializeQuizForm = () => {
  setRhymeTextBoxChangeEvent();
  setSelectBoxValueChoiceRhime();
  setChoiceInputFieldListDragAndDropEvent();
  setLinkAddChoiceClickEvent();
  // setLinkDeleteChoiceClickEvent();
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
  let SelectBoxValuRhymeeList = [];

  rhymeTextBoxElementList.forEach((rhymeTextBoxElement) => {
    optionValue = rhymeTextBoxElement.value;
    if (!optionValue) {
      return;
    }
    SelectBoxValuRhymeeList.push(optionValue);
    const optionHtml = `<option value="${optionValue}">${optionValue}</option>`;
    selectBoxOptionHtml += optionHtml;
  });

  const selectBoxChoiceRhymeElementList = document.querySelectorAll(
    SELECTBOX_SELECTOR_CHOICE_RHYME
  );

  selectBoxChoiceRhymeElementList.forEach((selectBoxChoiceRhymeElement) => {
    const selectValue = selectBoxChoiceRhymeElement.value;
    selectBoxChoiceRhymeElement.innerHTML = selectBoxOptionHtml;
    if (SelectBoxValuRhymeeList.includes(selectValue)) {
      selectBoxChoiceRhymeElement.value = selectValue;
    }
    selectBoxChoiceRhymeElement.animate(
      [{ opacity: '0' }, { opacity: '1' }],
      SELECTBOX_FADE_IN_TIME
    );
  });
};

/**
 * 選択肢の入力欄のリストにドラッグ＆ドロップのEventを設定する
 */
const setChoiceInputFieldListDragAndDropEvent = () => {
  document.querySelectorAll('.choice_input_field').forEach((elm) => {
    setChoiceInputFieldDragAndDropEvent(elm.id);
  });
};

/**
 * 選択肢の入力欄にドラッグ＆ドロップのEventを設定する
 */
const setChoiceInputFieldDragAndDropEvent = (id) => {
  const elm = document.getElementById(id);
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
};

/**
 * 選択肢追加ボタンのクリック時の処理を設定する
 */
const setLinkAddChoiceClickEvent = () => {
  const linkAddChoiceElement = document.getElementById('link_add_choice');
  linkAddChoiceElement.addEventListener('click', (event) => {
    addChoiceInputField();
  });
};

/**
 * 選択肢入力欄を追加する
 */
const addChoiceInputField = () => {
  const choiceInputFeildListElement = document.querySelector(
    '#choice_input_field_list'
  );

  const num = new Date().getTime().toString();

  const selectBoxOptions = document.querySelector(
    SELECTBOX_SELECTOR_CHOICE_RHYME
  ).innerHTML;

  const element = `<li id="choice_input_field_id_${num}" class="row choice_input_field" draggable="true">
    <div class="col-md-1 drag_and_drop_mark"quq></div>
    <div class="col-md-5">
    <input type="text" name="choice[][content]" id="txt_choice_id_${num}" value="" class="form-control">
    </div>
    <div class="col-md-5">
    <select name="choice[][rhyme]" id="select_choice_rhyme_id_${num}" class="form-control">${selectBoxOptions}</select>
    </div>
    <div class="col-md-1">
      <a onclick="deleteChoiceField('choice_input_field_id_${num}');" id="link_delete_choice_0" class="link_delete_choice link_delete" href="javascript:void(0);">×</a> 
    </div>
    </li>`;

  choiceInputFeildListElement.insertAdjacentHTML('beforeend', element);

  setChoiceInputFieldDragAndDropEvent(`choice_input_field_id_${num}`);

  switchDisplayOfLinkDeleteChoice();

  const choiceInputFieldCount = choiceInputFeildListElement.querySelectorAll(
    '.choice_input_field'
  ).length;

  if (choiceInputFieldCount >= CHOICE_INPUT_FIELD_MAX) {
    hideLinkAddChiceInputField();
  }
};

// const setSelectBoxOptions = (selectboxId) => {
//   const selectBoxOptions = document.querySelector(
//     SELECTBOX_SELECTOR_CHOICE_RHYME
//   ).innerHTML;

//   document.getElementById(selectboxId).innerHTML = selectBoxOptions;
// };

// const setLinkDeleteChoiceClickEvent = () => {
//   const linkDeleteChoiceElementList = document.querySelectorAll(
//     '.link_delete_choice'
//   );

//   linkDeleteChoiceElementList.forEach((linkDeleteChoiceElement) => {
//     linkDeleteChoiceElement.addEventListener('click', (event) => {
//       deleteChoiceField(event.target.id);
//     });
//   });
// };

// const deleteChoiceField = (id) => {
//   document.getElementById(id).remove();
// };

/**
 * 選択肢入力欄を非表示にする
 */
const hideLinkAddChiceInputField = () => {
  document
    .getElementById(SELECTOR_LINK_ADD_CHOICE_ID)
    .classList.add(CLASS_ELEMENT_DISPLAY_NONE);
};
