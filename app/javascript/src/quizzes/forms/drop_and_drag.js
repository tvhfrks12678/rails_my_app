import { Setting } from './setting.js';

const INPUT_FIELD_LIST_ITEM_DRAGSTART_CLASS = 'input_field_list_item_dragstart';
const INPUT_FIELD_LIST_ITEM_DRAGOVER_CLASS = 'input_field_list_item_dragover';

export const DropAndDrag = class {
  static setDragAndDrop() {
    const inputFieldListElement = document.querySelector(
      `.${Setting.CLASS.INPUT_FIELD.LIST}`
    );
    const inputFieldListItemElementList = document.querySelectorAll(
      `.${Setting.CLASS.INPUT_FIELD.LIST_ITEM}`
    );
    inputFieldListItemElementList.forEach((inputFieldListItemElement) => {
      DropAndDrag.setInputFieldListItemDragAndDropEvent(
        inputFieldListItemElement,
        inputFieldListElement
      );
    });
  }

  /**
   * 入力欄にドラッグ＆ドロップのEventを設定する
   * @param {Object} inputFieldListItemElement 入力欄のリストのアイテムのElement
   * @param {Object} inputFieldListElement 入力欄のリストのElement
   */
  static setInputFieldListItemDragAndDropEvent(
    inputFieldListItemElement,
    inputFieldListElement
  ) {
    const inputFeildMoveIcon = inputFieldListItemElement.querySelector(
      `.${Setting.CLASS.ICON.DRAG_AND_DROP}`
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
  }
};
