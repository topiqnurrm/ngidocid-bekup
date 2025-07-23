Set uniqueElement(List<int> myList) {
  // TODO 1
  // Convert the list to a set to remove duplicates and keep only unique elements
  return myList.toSet();
  // End of TODO 1
}

Map<String, String> buildFutsalPlayersMap() {
  // TODO 2
  // Build and return a map with futsal positions and player names
  return {
    'Goalkeeper': 'Andri',
    'Anchor': 'Irfan',
    'Pivot': 'Fikri',
    'Right Flank': 'Aldi',
    'Left Flank': 'Hafid'
  };
  // End of TODO 2
}

Map<String, String> updatePivotPlayer() {
  final futsalPlayers = buildFutsalPlayersMap();

  // TODO 3
  // Update the Pivot position to have player 'Fajar'
  futsalPlayers['Pivot'] = 'Fajar';
  // End of TODO 3

  return futsalPlayers;
}