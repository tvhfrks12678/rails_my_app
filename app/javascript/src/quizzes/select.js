const CHK_OFF_BACKGROUND_COLOR = 'transparent';
const CHK_ON_BACKGROUND_COLOR = '#0175fe';

window.addEventListener('DOMContentLoaded', (event) => {
  const quizChoiceCheckboxElementList = document.querySelectorAll(
    'input[type=checkbox]'
  );
  quizChoiceCheckboxElementList.forEach((quizChoiceCheckboxElement) => {
    quizChoiceCheckboxElement.addEventListener('change', (event) => {
      changeChoiceBackgroundColor(event.target.id);
    });
  });
});

/**
 * 選択肢の背景色を変更する
 * @param {string} checkboxId
 */
const changeChoiceBackgroundColor = (checkboxId) => {
  const checkboxElement = document.getElementById(checkboxId);
  const choiceElementStyle = checkboxElement.parentNode.style;

  if (checkboxElement.checked) {
    choiceElementStyle.color = 'white';
    choiceElementStyle.backgroundColor = CHK_ON_BACKGROUND_COLOR;
    return;
  }

  choiceElementStyle.color = CHK_ON_BACKGROUND_COLOR;
  choiceElementStyle.backgroundColor = CHK_OFF_BACKGROUND_COLOR;
};
