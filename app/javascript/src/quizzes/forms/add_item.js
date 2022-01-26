import { RhymeDataList } from './rhyme_data_list.js';
import { DropAndDrag } from './drop_and_drag.js';
import { Delete } from './delete.js';
import { Display } from './display.js';
import { Setting } from './setting.js';

const RHYME_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML = `
	<div>
	<i class="fa fa-sort fa-lg icon_action icon_sort_input_field_list_item" aria-hidden="true" draggable="true"></i>
	</div>
	<div class="input_field_list_item_box">
		<input name="choices[][content]" class="form-control" type="text" value="">
	</div>
	<div class="input_field_list_item_box">
		<input name="choices[][rhyme]" class="form-control" list="list_choice_rhyme" type="text" value="">
	</div>
	<div>
	<i class="fa fa-trash fa-lg icon_action icon_delete_input_field_list_item" aria-hidden="true"></i>
	</div>
`;

const CHOICE_INPUT_FIELD_LIST_ITEM_PREFIX_ID = 'choice_input_field_id_';

export const AddItem = class {
  static createAddInputFieldListItemElement() {
    let addInputFieldListItemElement = document.createElement('li');
    const num = new Date().getTime().toString();
    const inputFieldId = CHOICE_INPUT_FIELD_LIST_ITEM_PREFIX_ID + num;
    addInputFieldListItemElement.id = inputFieldId;
    addInputFieldListItemElement.classList.add(
      Setting.CLASS.INPUT_FIELD.LIST_ITEM
    );
    addInputFieldListItemElement.insertAdjacentHTML(
      'afterbegin',
      RHYME_INPUT_FIELD_LIST_ITEM_CONTENT_STRING_HTML
    );

    RhymeDataList.setRhymeTextBoxChangeEvent(addInputFieldListItemElement);

    return addInputFieldListItemElement;
  }

  static addInputFieldListItem() {
    const addInputFieldListItemElement =
      this.createAddInputFieldListItemElement();

    const choiceInputFieldListElement = document.getElementById(
      Setting.ID.CHOICE.INPUT_FIELD.LIST
    );

    choiceInputFieldListElement.insertAdjacentElement(
      'beforeend',
      addInputFieldListItemElement
    );

    RhymeDataList.setAllRhymeTextBoxChangeEvent();
    Delete.setInputFieldListItemDeleteIconClickEvent();

    DropAndDrag.setInputFieldListItemDragAndDropEvent(
      addInputFieldListItemElement,
      choiceInputFieldListElement
    );
  }

  static setIconAddInputFieldClickEvent() {
    const iconAddElement = document.querySelector(`.${Setting.CLASS.ICON.ADD}`);
    iconAddElement.addEventListener('click', () => {
      this.addInputFieldListItem();

      new Display().switchDisableDisplay();
    });
  }
};
