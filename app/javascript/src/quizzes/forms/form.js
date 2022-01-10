import { Display } from './display.js';
import { RhymeDataList } from './rhyme_data_list.js';
import { AddItem } from './add_item.js';
import { DropAndDrag } from './drop_and_drag.js';
import { Delete } from './delete.js';

window.addEventListener('DOMContentLoaded', (event) => {
  setChoiceInputFieldEventListner();
});

const setChoiceInputFieldEventListner = () => {
  Delete.setInputFieldListItemDeleteIconClickEvent();
  RhymeDataList.setAllRhymeTextBoxChangeEvent();
  AddItem.setIconAddInputFieldClickEvent();
  DropAndDrag.setDragAndDrop();
  new Display().switchDisableDisplay();
};
