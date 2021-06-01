const INPUT_FIELD_LIST_ITEM_CLASS = 'input_field_list_item';
const RHYME_INPUT_FIELD_LIST_CLASS = 'rhyme_input_field_list';
const INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS = 'input_field_list_item_dragstart';
const INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS = 'input_field_list_item_dragover';

const LINK_DELETE_CLASS = 'link_delete';
const RHYME_INPUT_FIELD_LIST_ITEM_MIN = 1;

window.addEventListener('DOMContentLoaded', (event) => {
  initializeQuizForm();
});

const initializeQuizForm = () => {
  setRhymeTextBoxChangeEvent();
  setSelectBoxValueChoiceRhime();
  setChoiceInputFieldListDragAndDropEvent();
  setLinkAddChoiceClickEvent();
  setRhymeInputFieldListDragAndDropEvent();
  setRhymeInputFieldListDeleteLinkClickEvent();
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

/**
 * 選択肢入力欄を非表示にする
 */
const hideLinkAddChiceInputField = () => {
  document
    .getElementById(SELECTOR_LINK_ADD_CHOICE_ID)
    .classList.add(CLASS_ELEMENT_DISPLAY_NONE);
};

/**
 * 母音の入力欄のListにドラッグ＆ドロップのEventを設定する
 */
const setRhymeInputFieldListDragAndDropEvent = () => {
  const rhymeInputFieldListItems = document.querySelectorAll(
    `#${RHYME_INPUT_FIELD_LIST_CLASS} .${INPUT_FIELD_LIST_ITEM_CLASS}`
  );

  rhymeInputFieldListItems.forEach((rhymeInputFieldListItem) => {
    setInputFieldListItemDragAndDropEvent(rhymeInputFieldListItem.id);
  });
};

/**
 * 入力欄にドラッグ＆ドロップのEventを設定する
 * @param {string} id 入力欄のID
 */
const setInputFieldListItemDragAndDropEvent = (id) => {
  const element = document.getElementById(id);

  element.addEventListener('dragstart', (ev) => {
    ev.dataTransfer.setData('text/plain', ev.target.id);
    element.classList.add(INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS);
  });

  element.addEventListener('dragover', (ev) => {
    ev.preventDefault();
    ev.currentTarget.classList.add(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);
  });

  element.addEventListener('dragleave', (ev) => {
    ev.currentTarget.classList.remove(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);
  });

  element.addEventListener('drop', (ev) => {
    ev.preventDefault();

    const dragElementId = ev.dataTransfer.getData('text/plain');
    const dragElement = document.getElementById(dragElementId);

    const dropElement = ev.currentTarget;
    dropElement.parentNode.insertBefore(dragElement, dropElement);
    dropElement.classList.remove(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);
  });

  element.addEventListener('dragend', () => {
    element.classList.remove(INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS);
  });
};

/**
 * 母音の入力欄のListに削除リンククリック時のEventを設定する
 */
const setRhymeInputFieldListDeleteLinkClickEvent = () => {
  const rhymeInputFieldListItemElementList = document.querySelectorAll(
    `#${RHYME_INPUT_FIELD_LIST_CLASS} .${INPUT_FIELD_LIST_ITEM_CLASS}`
  );
  rhymeInputFieldListItemElementList.forEach(
    (rhymeInputFieldListItemElement) => {
      const rhymeInputFieldListItemDeleteLinkElement =
        rhymeInputFieldListItemElement.querySelector(`.${LINK_DELETE_CLASS}`);
      setDeleteClickEvent(
        rhymeInputFieldListItemElement,
        rhymeInputFieldListItemDeleteLinkElement
      );
    }
  );
};

/**
 * 母音の入力欄のに削除リンククリック時のEventを設定する
 * @param  {object} itemElement 削除するElement
 * @param  {object} DeleteElement 削除Element
 */
const setDeleteClickEvent = (itemElement, DeleteElement) => {
  DeleteElement.addEventListener('click', () => {
    itemElement.remove();

    const rhymeInputFieldListItemElementList = document.querySelectorAll(
      `#${RHYME_INPUT_FIELD_LIST_CLASS} .${INPUT_FIELD_LIST_ITEM_CLASS}`
    );

    if (
      rhymeInputFieldListItemElementList.length >
      RHYME_INPUT_FIELD_LIST_ITEM_MIN
    ) {
      return;
    }

    rhymeInputFieldListItemElementList.forEach(
      (rhymeInputFieldListItemElement) => {
        rhymeInputFieldListItemElement
          .querySelector(`.${LINK_DELETE_CLASS}`)
          .classList.add(CLASS_ELEMENT_DISPLAY_NONE);
      }
    );
  });
};
