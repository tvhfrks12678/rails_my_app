import { Setting } from './setting.js';

const CHOICE_INPUT_FIELD_LIST_ITEM_MAX = 15;
const CHOICE_INPUT_FIELD_LIST_ITEM_MIN = 3;

export const Display = class {
  constructor(itemClass = Setting.CLASS.ICON.DELETE) {
    const element = document.querySelectorAll(`.${itemClass}`);
    this.itemElement = element;
    this.itemCount = element.length;
  }
  switchDisableDisplay() {
    this.switchInputFieldListDeleteIconDisable();
    this.switchDisplayAddButton();
  }

  /**
   * 入力欄のListのItemの削除IconのDisableを切り替える
   */
  switchInputFieldListDeleteIconDisable() {
    if (this.itemCount <= CHOICE_INPUT_FIELD_LIST_ITEM_MIN) {
      this.itemElement.forEach((deleteIconElement) => {
        deleteIconElement.classList.add(Setting.CLASS.ICON.DISABLE);
      });
      return;
    }

    this.itemElement.forEach((deleteIconElement) => {
      deleteIconElement.classList.remove(Setting.CLASS.ICON.DISABLE);
    });
  }

  switchDisplayAddButton() {
    const iconAddElement = document.querySelector(`.${Setting.CLASS.ICON.ADD}`);

    if (this.itemCount >= CHOICE_INPUT_FIELD_LIST_ITEM_MAX) {
      return iconAddElement.classList.add(Setting.CLASS.ICON.DISABLE);
    }

    iconAddElement.classList.remove(Setting.CLASS.ICON.DISABLE);
  }
};
