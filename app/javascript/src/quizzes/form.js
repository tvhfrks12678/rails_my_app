const CHOICE_INPUT_FIELD_ID = 'choice_input_field';

const CHOICE_INPUT_FIELD_LIST_ID = 'choice_input_field_list';
const INPUT_FIELD_LIST_ITEM_CLASS = 'input_field_list_item';
const INPUT_FIELD_LIST_CLASS = 'input_field_list';

const DRAG_AND_DROP_ICON_CLASS = 'fa-sort';
const DELETE_ICON_CLASS = 'fa-trash';
const ICON_ADD_CLASS = 'fa-plus-circle';
const ICON_CLICK_DISABLE_CLASS = 'icon_click_disable';

const INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS = 'input_field_list_item_dragstart';
const INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS = 'input_field_list_item_dragover';

const CHOICE_INPUT_FIELD_LIST_ITEM_MAX = 10;
const CHOICE_INPUT_FIELD_LIST_ITEM_MIN = 3;

const RHYME_INPUT_FIELD_LIST_ITEM_MIN = 1;
const RHYME_INPUT_FIELD_LIST_ITEM_MAX = 5;

const ICON_ADD_CHOICE_INPUT_FIELD_LIST_ITEM =
  'icon_add_choice_input_field_list_item';

const RHYME_INPUT_FIELD_ID = 'rhyme_input_field';
const RHYME_INPUT_FIELD_LIST_ID = 'rhyme_input_field_list';

const CHOICE_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML = `
  <div>
    <i class="fa fa-sort fa-lg icon_action icon_sort_input_field_list_item" aria-hidden="true" draggable="true"></i>
  </div>
  <div class="input_field_list_item_box">
    <input name="choice[][content]" class="form-control" type="text">
  </div>
  <div class="input_field_list_item_box">
    <select name="choice[][rhyme]" class="form-control"><option selected="selected" value="">韻なし</option></select>
  </div>
  <div>
    <i class="fa fa-trash fa-lg icon_action icon_delete_input_field_list_item" aria-hidden="true"></i>
  </div>
`;

const CHOICE_INPUT_FIELD_LIST_ITEM_PREFIX_ID = 'choice_input_field_id_';

const RHYME_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML = `
  <div>
  <i class="fa fa-sort fa-lg icon_action icon_sort_input_field_list_item" aria-hidden="true" draggable="true"></i>
  </div>
  <div class="input_field_list_item_box">
    <input name="rhyme[][content]" class="form-control" type="text">
  </div>
  <div>
  <i class="fa fa-trash fa-lg icon_action icon_delete_input_field_list_item" aria-hidden="true"></i>
  </div>
`;

const RHYME_INPUT_FIELD_LIST_ITEM_PREFIX_ID = 'rhyme_input_field_id_';

const TEXTBOX_SELECTOR_RHYME = "input[name='rhyme[][content]']";
const SELECTBOX_SELECTOR_CHOICE_RHYME = 'select[name="choice[][rhyme]"]';
const SELECTBOX_OPTION_INIT_ITEM = '韻なし';
const SELECTBOX_FADE_IN_TIME = '1500';

window.addEventListener('DOMContentLoaded', (event) => {
  initializeQuizForm();
});

const initializeQuizForm = () => {
  setChoiceInputFieldEventListner();

  setRhymeInputFieldEventListner();
};

const setChoiceInputFieldEventListner = () => {
  const InputFieldElement = document.getElementById(CHOICE_INPUT_FIELD_ID);
  setInputFieldListEventLister(
    CHOICE_INPUT_FIELD_LIST_ID,
    InputFieldElement,
    CHOICE_INPUT_FIELD_LIST_ITEM_MIN
  );

  setIconAddInputFieldClickEvent(
    InputFieldElement,
    CHOICE_INPUT_FIELD_LIST_ITEM_PREFIX_ID,
    CHOICE_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML,
    CHOICE_INPUT_FIELD_LIST_ITEM_MAX,
    CHOICE_INPUT_FIELD_LIST_ITEM_MIN
  );
  switchInputFieldListDeleteIconDisable(
    InputFieldElement,
    CHOICE_INPUT_FIELD_LIST_ITEM_MIN
  );
};

const setRhymeInputFieldEventListner = () => {
  const rhymeInputFieldElement = document.getElementById(RHYME_INPUT_FIELD_ID);
  setInputFieldListEventLister(
    RHYME_INPUT_FIELD_LIST_ID,
    rhymeInputFieldElement,
    RHYME_INPUT_FIELD_LIST_ITEM_MIN
  );

  setIconAddInputFieldClickEvent(
    rhymeInputFieldElement,
    RHYME_INPUT_FIELD_LIST_ITEM_PREFIX_ID,
    RHYME_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML,
    RHYME_INPUT_FIELD_LIST_ITEM_MAX,
    RHYME_INPUT_FIELD_LIST_ITEM_MIN
  );

  switchInputFieldListDeleteIconDisable(
    rhymeInputFieldElement,
    RHYME_INPUT_FIELD_LIST_ITEM_MIN
  );

  setRhymeTextBoxChangeEvent();
};

/**
 * 入力欄にEventを設定する
 * @param  {string} inputFieldListId 入力欄のID
 */
const setInputFieldListEventLister = (
  inputFieldListId,
  inputFieldElement,
  inputFieldListItemMin
) => {
  const inputFieldListElement = document.getElementById(inputFieldListId);
  const inputFieldListItemElementList = inputFieldListElement.querySelectorAll(
    `.${INPUT_FIELD_LIST_ITEM_CLASS}`
  );
  inputFieldListItemElementList.forEach((inputFieldListItemElement) => {
    setInputFieldListItemDragAndDropEvent(
      inputFieldListItemElement,
      inputFieldListElement
    );
    setInputFieldListItemDeleteIconClickEvent(
      inputFieldListItemElement,
      inputFieldElement,
      inputFieldListItemMin
    );
  });
};

/**
 * 入力欄にドラッグ＆ドロップのEventを設定する
 * @param {Object} inputFieldListItemElement 入力欄のリストのアイテムのElement
 * @param {Object} inputFieldListElement 入力欄のリストのElement
 */
const setInputFieldListItemDragAndDropEvent = (
  inputFieldListItemElement,
  inputFieldListElement
) => {
  const inputFeildMoveIcon = inputFieldListItemElement.querySelector(
    `.${DRAG_AND_DROP_ICON_CLASS}`
  );

  inputFeildMoveIcon.addEventListener('dragstart', (ev) => {
    ev.dataTransfer.setData('text/plain', inputFieldListItemElement.id);
    inputFieldListItemElement.classList.add(
      INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS
    );
  });

  inputFieldListItemElement.addEventListener('dragover', (ev) => {
    ev.preventDefault();

    ev.currentTarget.classList.add(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);
  });

  inputFieldListItemElement.addEventListener('dragleave', (ev) => {
    ev.currentTarget.classList.remove(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);
  });

  inputFieldListItemElement.addEventListener('drop', (ev) => {
    ev.preventDefault();

    const dragElementId = ev.dataTransfer.getData('text/plain');
    const dragElement = document.getElementById(dragElementId);
    const dropElement = ev.currentTarget;

    dropElement.classList.remove(INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS);

    if (!inputFieldListElement.contains(dragElement)) {
      return;
    }

    inputFieldListElement.insertBefore(dragElement, dropElement);
  });

  inputFieldListItemElement.addEventListener('dragend', () => {
    inputFieldListItemElement.classList.remove(
      INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS
    );
  });
};

/**
 * 母音の入力欄の削除リンククリック時のEventを設定する
 * @param  {Object} inputFeildListItemElement 入力欄のListのItemのElement
 */
const setInputFieldListItemDeleteIconClickEvent = (
  inputFeildListItemElement,
  inputFeildElement,
  inputFeildListItemMin
) => {
  const deleteIconElement = inputFeildListItemElement.querySelector(
    `.${DELETE_ICON_CLASS}`
  );

  deleteIconElement.addEventListener('click', () => {
    inputFeildListItemElement.remove();

    switchInputFieldListDeleteIconDisable(
      inputFeildElement,
      inputFeildListItemMin
    );

    const addIconElement = inputFeildElement.querySelector(
      `.${ICON_ADD_CLASS}`
    );

    addIconElement.classList.remove(ICON_CLICK_DISABLE_CLASS);
  });
};

/**
 * 入力欄のListのItemの削除IconのDisableを切り替える
 */
const switchInputFieldListDeleteIconDisable = (
  inputFieldElement,
  inputFeildListItemMin
) => {
  const deleteIconElementList = inputFieldElement.querySelectorAll(
    `.${DELETE_ICON_CLASS}`
  );
  if (deleteIconElementList.length <= inputFeildListItemMin) {
    deleteIconElementList.forEach((deleteIconElement) => {
      deleteIconElement.classList.add(ICON_CLICK_DISABLE_CLASS);
    });
    return;
  }

  deleteIconElementList.forEach((deleteIconElement) => {
    deleteIconElement.classList.remove(ICON_CLICK_DISABLE_CLASS);
  });
};

const setIconAddClickEvent = (inputFieldElement, inputFieldListItemMax) => {
  iconAddElement = inputFieldElement.querySelector(`.${ICON_ADD_CLASS}`);

  iconAddElement.addEventListener('click', () => {
    addChoiceInputFieldListItem(inputFieldElement);

    const inputFieldListItemCount = inputFieldElement.querySelectorAll(
      `.${INPUT_FIELD_LIST_ITEM_CLASS}`
    ).length;

    if (inputFieldListItemCount >= inputFieldListItemMax) {
      iconAddElement.classList.add(ICON_CLICK_DISABLE_CLASS);
    }
  });
};

const setIconAddInputFieldClickEvent = (
  inputFieldElement,
  inputfieldListItemPrefixId,
  inputfieldListItemContent,
  inputFieldListItemMax,
  inputFieldListItemMin
) => {
  const iconAddElement = inputFieldElement.querySelector(`.${ICON_ADD_CLASS}`);
  iconAddElement.addEventListener('click', () => {
    const addInputFieldListItemElement = createAddInputFieldListItemElement(
      inputfieldListItemPrefixId,
      inputfieldListItemContent
    );

    addInputFieldListItem(
      inputFieldElement,
      addInputFieldListItemElement,
      inputFieldListItemMin
    );

    const inputFieldListItemCount = inputFieldElement.querySelectorAll(
      `.${INPUT_FIELD_LIST_ITEM_CLASS}`
    ).length;

    if (inputFieldListItemCount >= inputFieldListItemMax) {
      iconAddElement.classList.add(ICON_CLICK_DISABLE_CLASS);
    }

    switchInputFieldListDeleteIconDisable(
      inputFieldElement,
      inputFieldListItemMin
    );
  });
};

const addInputFieldListItem = (
  inputFieldElement,
  addInputFieldListItemElement,
  inputFieldListItemMin
) => {
  inputFieldListElement = inputFieldElement.querySelector(
    `.${INPUT_FIELD_LIST_CLASS}`
  );

  inputFieldListElement.insertAdjacentElement(
    'beforeend',
    addInputFieldListItemElement
  );

  setInputFieldListItemEventLister(
    addInputFieldListItemElement,
    inputFieldListElement,
    inputFieldElement,
    inputFieldListItemMin
  );
};

const createAddInputFieldListItemElement = (prefixId, listItemContent) => {
  let addInputFieldListItemElement = document.createElement('li');
  const num = new Date().getTime().toString();

  const inputFieldId = prefixId + num;
  addInputFieldListItemElement.id = inputFieldId;
  addInputFieldListItemElement.classList.add(INPUT_FIELD_LIST_ITEM_CLASS);
  addInputFieldListItemElement.insertAdjacentHTML(
    'afterbegin',
    listItemContent
  );

  const selectBoxElement = addInputFieldListItemElement.querySelector(
    "input[name='rhyme[][content]']"
  );

  if (!(selectBoxElement === null)) {
    selectBoxElement.addEventListener('change', () => {
      setSelectBoxValueChoiceRhime();
    });
  }

  return addInputFieldListItemElement;
};

const setInputFieldListItemEventLister = (
  inputFieldListItemElement,
  inputFieldListElement,
  inputFieldElement,
  inputFieldListItemMin
) => {
  setInputFieldListItemDragAndDropEvent(
    inputFieldListItemElement,
    inputFieldListElement
  );
  setInputFieldListItemDeleteIconClickEvent(
    inputFieldListItemElement,
    inputFieldElement,
    inputFieldListItemMin
  );
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
