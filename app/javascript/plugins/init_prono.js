const initProno = () => {
  const playerBoxInputs = document.querySelectorAll('.player-name input');
  const playerResultButtons = document.querySelectorAll('.player-result .fa-check-circle');
  const formPlayerBoxes = document.querySelectorAll('.form-player-box');
  const playerBoxes = document.querySelectorAll('.player-box');

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
    let even = first_or_second_player(isEven(event.currentTarget.parentNode.parentNode.id.slice(-2)));
    formPlayerBoxes.forEach((element) => {
      if (parseInt(element.id.slice(-2), 10) === last_index && element.dataset.player === even ) {
        descendants.push(element);
        last_index = parseInt(element.dataset.prono, 10);
        even = first_or_second_player(isEven(element.id.slice(-2)));
      }
    })
    descendants.push(document.querySelector('#final'));
    descendants.forEach((descendant) => {
      const other_player = find_other_player(event.currentTarget.parentNode.parentNode);
      let other_player_name = '';
      if (event.currentTarget.parentNode.parentNode.parentNode.classList.contains('game-box')) {
        other_player_name = other_player.querySelector('.player-name').innerText;
      } else {
        if (other_player === undefined) { return };
        other_player_name = other_player.querySelector('.player-name input').value;
      }
      if (descendant.querySelector('.player-name input').value === other_player_name && other_player_name != '') {
        changeNameAndSeed(event, descendant);
      }
    })
  }

  const changeNameAndSeed = (event, element) => {
    if (event.currentTarget.parentNode.parentNode.parentNode.classList.contains('game-box')) {
      element.querySelector('.player-name input').value = event.currentTarget.parentNode.parentNode.querySelector('.player-name').innerText;
      element.querySelector('.player-seed').innerText = event.currentTarget.parentNode.parentNode.querySelector('.player-seed').innerText;
    } else {
      element.querySelector('.player-name input').value = event.currentTarget.parentNode.parentNode.querySelector('.player-name input').value;
      element.querySelector('.player-seed').innerText = event.currentTarget.parentNode.parentNode.querySelector('.player-seed').innerText;
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
        } else if (isEven(event.currentTarget.parentNode.parentNode.id.slice(-2))) {
          const nextPlayerBox = Array.from(nextPlayerBoxes).find(element => element.dataset.player === 'second');
          changeNameAndSeed(event, nextPlayerBox);
          changeFollowingResults(event);
        } else {
          const nextPlayerBox = Array.from(nextPlayerBoxes).find(element => element.dataset.player === 'first');
          changeNameAndSeed(event, nextPlayerBox);
          changeFollowingResults(event);
        }
      });
    });
  }
}

export { initProno };
