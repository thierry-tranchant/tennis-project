const initProno = () => {

  const test = document.querySelectorAll('textarea');
  const playerBoxInputs = document.querySelectorAll('.player-name textarea');
  const playerResultButtons = document.querySelectorAll('.player-result .fa-check-circle');
  const formPlayerBoxes = document.querySelectorAll('.form-player-box');
  const playerBoxes = document.querySelectorAll('.player-box');
  const regexp = new RegExp('[0-9]+')

  const isEven = n => n % 2 === 0;

  const first_or_second_player = (even) => {
    if (even) {
      return 'second'
    } else {
      return 'first'
    }
  }

  const find_other_player = (player) => {
    if (player.dataset.player === 'second') {
      let other_player = Array.from(formPlayerBoxes).find(element => element.id === player.id && element.dataset.player === 'first');
      if (other_player === undefined) {
        other_player = Array.from(playerBoxes).find(element => element.id === player.id && element.dataset.player === 'first');
        return other_player
      }
      return other_player
    } else {
      let other_player = Array.from(formPlayerBoxes).find(element => element.id === player.id && element.dataset.player === 'second');
      if (other_player === undefined) {
        other_player = Array.from(playerBoxes).find(element => element.id === player.id && element.dataset.player === 'second');
        return other_player
      }
      return other_player
    }
  }

  const changeFollowingResults = (event) => {
    const descendants = [];
    let last_index = parseInt(event.currentTarget.parentNode.parentNode.dataset.prono, 10);
    let even = first_or_second_player(isEven(regexp.exec(event.currentTarget.parentNode.parentNode.id)));
    formPlayerBoxes.forEach((element) => {
      if (parseInt(regexp.exec(element.id), 10) === last_index && element.dataset.player === even) {
        descendants.push(element);
        last_index = parseInt(element.dataset.prono, 10);
        even = first_or_second_player(isEven(regexp.exec(element.id)));
        console.log(last_index);
        console.log(even);

      }
    })
    descendants.push(document.querySelector('#final'));
    console.log(descendants);
    descendants.forEach((descendant) => {
      const other_player = find_other_player(event.currentTarget.parentNode.parentNode);
      let other_player_name = '';
      if (event.currentTarget.parentNode.parentNode.parentNode.classList.contains('game-box')) {
        other_player_name = other_player.querySelector('.player-name').innerText;
      } else {
        if (other_player === undefined) { return };
        other_player_name = other_player.querySelector('.player-name textarea').value;
      }
      if (descendant.querySelector('.player-name textarea').value === other_player_name && other_player_name != '') {
        changeNameAndSeed(event, descendant);
      }
    })
  }

  const changeNameAndSeed = (event, element) => {
    if (event.currentTarget.parentNode.parentNode.parentNode.classList.contains('game-box')) {
      element.querySelector('.player-name textarea').value = event.currentTarget.parentNode.parentNode.querySelector('.player-name').innerText;
      // element.querySelector('.player-seed').innerText = event.currentTarget.parentNode.parentNode.querySelector('.player-seed').innerText;
    } else {
      element.querySelector('.player-name textarea').value = event.currentTarget.parentNode.parentNode.querySelector('.player-name textarea').value;
      // element.querySelector('.player-seed').innerText = event.currentTarget.parentNode.parentNode.querySelector('.player-seed').innerText;
    }
  }

  const checkInputLength = (element) => {
    let playerName = element.value;
    if (playerName === '') {
      return;
    }
    const playerNameArray = playerName.split(' ');
    if (playerNameArray[2] && playerNameArray[0].length + playerNameArray[1].length + playerNameArray[2].length + 2 >= 23) {
      element.setAttribute('rows', 3);
    } else if (playerNameArray[2] && playerNameArray[0].length + playerNameArray[1].length + playerNameArray[2].length + 2 > 13) {
      element.setAttribute('rows', 2);
    } else if (playerNameArray[0].length + playerNameArray[1].length + 1 > 26) {
      element.setAttribute('rows', 3);
    } else if (playerNameArray[0].length + playerNameArray[1].length + 1 > 13) {
      element.setAttribute('rows', 2);
    } else {
      element.setAttribute('rows', 1);
    }
  }

  if (document.querySelector('#prono-tournament-table')) {
    playerResultButtons.forEach((button) => {
      button.addEventListener('click', (event) => {
        const nextPlayerBoxes = document.querySelectorAll(`#game-${event.currentTarget.parentNode.parentNode.dataset.prono}`);
        if (nextPlayerBoxes.length === 0) {
          const nextPlayerBox = document.querySelector('#final');
          changeNameAndSeed(event, nextPlayerBox);
          changeFollowingResults(event);
        } else if (isEven(regexp.exec(event.currentTarget.parentNode.parentNode.id))) {
          const nextPlayerBox = Array.from(nextPlayerBoxes).find(element => element.dataset.player === 'second');
          changeNameAndSeed(event, nextPlayerBox);
          changeFollowingResults(event);
        } else {
          const nextPlayerBox = Array.from(nextPlayerBoxes).find(element => element.dataset.player === 'first');
          changeNameAndSeed(event, nextPlayerBox);
          changeFollowingResults(event);
        }
        test.forEach((element) => {
          checkInputLength(element);
        });
      });
    });
  }
}

export { initProno };
