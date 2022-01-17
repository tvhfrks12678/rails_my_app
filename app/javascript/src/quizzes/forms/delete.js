import { Setting } from './setting.js';
import { Display } from './display.js';

export const Delete = class {
  /**
   * 母音の入力欄の削除リンククリック時のEventを設定する
   */
  static setInputFieldListItemDeleteIconClickEvent() {
    const inputFieldListItemElementList = document.querySelectorAll(
      `.${Setting.CLASS.INPUT_FIELD.LIST_ITEM}`
    );

    inputFieldListItemElementList.forEach((inputFieldListItemElement) => {
      const deleteIconElement = inputFieldListItemElement.querySelector(
        `.${Setting.CLASS.ICON.DELETE}`
      );

      deleteIconElement.addEventListener('click', () => {
        inputFieldListItemElement.remove();
        new Display().switchDisableDisplay();
      });
    });
  }
};
