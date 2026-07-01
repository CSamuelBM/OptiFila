enum TurnStatus {
  waiting,
  inProgress,
  completed,
  canceled,
  missed;

  static TurnStatus fromBackend(String value){
    switch(value){
      case 'WAITING':
        return TurnStatus.waiting;
      case 'IN_PROGRESS':
        return TurnStatus.inProgress;
      case 'COMPLETED':
        return TurnStatus.completed;
      case 'CANCELED':
        return TurnStatus.canceled;
      case 'MISSED':
        return TurnStatus.missed;
      default:
        return TurnStatus.waiting;
    }
  }

  // Texto para la UI (NO backend)
  String toSpanish(){
    switch(this){
      case TurnStatus.waiting:
        return 'En espera';
      case TurnStatus.inProgress:
        return 'En atención';
      case TurnStatus.completed:
        return 'Completado';
      case TurnStatus.canceled:
        return 'Cancelado';
      case TurnStatus.missed:
        return 'No asistió';
    }
  }

  // Enviar status al backend
  String toBackend(){
    switch (this) {
      case TurnStatus.waiting:
        return 'WAITING';
      case TurnStatus.inProgress:
        return 'IN_PROGRESS';
      case TurnStatus.completed:
        return 'COMPLETED';
      case TurnStatus.canceled:
        return 'CANCELED';
      case TurnStatus.missed:
        return 'MISSED';
    }
  }
}