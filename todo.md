# Rick TODO list  

- Salvataggi tramite managers/minigames.gd . all_exited_interactions  
    Credo di fare una cosa tipo si salva i nomi delle interazioni, che devono essere univoci, e le usa per gestire i caricamenti.  
    Magari faccio in modo da generare dinamicamente, all'avvio del gioco, tutte le scene, in funzione dei salvataggi che ci sono, quindi nel GameManager quando si avvia magari una funzione _load_game() che si legge il file, con un determinato parsing, prende tutte le info, e crea le scene di conseguenza.  
    La posizione del giocatore, chissene... Respawna sempre all'inizio, cambia poco.

    Potrei anche fare, invece che generare dinamicamente tutto da zero, che si genera sempre tutto nel modo giusto, ma magari quando il giocatore clicca play il gioco distrugge i nodi con un nome che sta dentro quell'array di exited interactions.

    Bisogna, oltre a gestire le interazione, gestire l'inventario, quindi con l'array di oggetti nell'inventario lo "ripopolo" e tolgo la roba che ho raccolto dalle scene.