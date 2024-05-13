# taches

une application Flutter qui permet la gestion d’une liste de tâches

## Fonctionalité
- Saisie simple d’une phrase, après validation de la saisie, la tâche se retrouve dans la liste.

- Un clique sur la tâche permet de la proposer à la modification.

- Possibilité d’ajouter une description et une date d’échéance ainsi qu’une adresse. Ces informations s’affichent qd on demande le détail d’une tâche. Pour l’adresse, une carte doit s’afficher et indiquer le lieu (voir l’exemple du cours). Sous la carte doit apparaitre deux ou trois informations météo du moment pour le lieu (au moins température min/actuelle/max et une image d’illustration de cette météo : soleil, nuage, pluie, …​ voir l’exemple du cours).

- Dans le cas d’une tâche datée, la date doit être visible dans la liste sous forme de sous-titre.

- Un marqueur d’importance de la tâche doit être visible en face (un seul niveau d’importance : important/pas important).

- Une poubelle également doit être visible en bout de tâche. La suppression se fait en cliquant et confirmant la suppression ou par glissement de la tâche vers la droite ou la gauche (au choix)

- Le tri normal se fait par : l’importance de la tâche (flag d’importance) puis par la date de saisie ou de dernière modification

- Le tri doit être possible à l’aide d’un bouton par date d’échénance (de la plus récente à la plus vielle, et en cas d’égalité, par ordre d’ajout ou modification).

- Une tâche marquée terminée se retrouve en bas marquée comme tel (en grisée et case cochée). On peut décocher une tâche pour la retrouver dans la liste des tâches actives (selon le tri habituel, par date d’échéance d’abord, puis date modif sinon).

- Une préférence de l’appli permet de dire comment les tâches terminées doivent apparaitre ou pas dans la liste. Si elle n’apparaissent pas dans la liste des tâches, un bouton doit être présent pour les exhiber

## Quelque racourcis
- Double clique sur la tache pour la finir/reactiver
- Glisser une tache pour la supprimer

## Un petit truc en plus

- On ne peut pas creer une même tache
- Si on fourni une adresse elle doit exister


## API utilisé
- Google Maps
- openweathermap

## Dependances
- cached_network_image: ^3.3.1
- date_field: ^5.0.1
- flutter_map: ^3.0.0
- cupertino_icons: ^1.0.6
- http: ^0.13.6
- uuid: ^4.4.0
- geocoder2: ^1.4.0
- google_maps_flutter: ^2.6.1
- shared_preferences: ^2.0.0

