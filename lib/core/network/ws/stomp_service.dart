import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompService {
  StompClient? _stompClient;
  bool _isConnected = false;

  // Mapa para guardar las funciones de desuscripción asociadas a cada tópico
  final Map<String, StompUnsubscribe> _subscriptions = {};

  bool get isConnected => _isConnected;

  void connect({required VoidCallback onConnected}) {
    if (_stompClient != null && _stompClient!.isActive) return;

    const wsUrl = 'wss://backi251-optifila-backend.hf.space/api/v1/ws-queue/websocket';

    _stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (StompFrame frame) {
          _isConnected = true;
          debugPrint('✅ WS Conectado exitosamente');
          onConnected();
        },
        onWebSocketError: (dynamic error) {
          debugPrint('❌ Error WS Crítico: $error');
        },
        onStompError: (StompFrame frame) {
          debugPrint('❌ Error STOMP: ${frame.body}');
        },
        onDisconnect: (StompFrame frame) {
          _isConnected = false;
          _subscriptions.clear(); // Limpiamos la memoria al desconectar
          debugPrint('⚠️ WS Desconectado');
        },

        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _stompClient!.activate();
  }

  void subscribe(String topic, void Function(String) onMessage) {
    if (!_isConnected || _stompClient == null) {
      throw Exception('No se puede suscribir: El WebSocket no está conectado');
    }

    // Evitamos suscribirnos múltiples veces al mismo canal
    if (_subscriptions.containsKey(topic)) {
      debugPrint('⚠️ Ya existe una suscripción activa para el tópico: $topic');
      return;
    }

    final unsubscribeFn = _stompClient!.subscribe(
      destination: topic,
      callback: (StompFrame frame) {
        if (frame.body != null) {
          onMessage(frame.body!);
        }
      },
    );

    // Guardamos la función devuelta en nuestro mapa usando el tópico como llave
    _subscriptions[topic] = unsubscribeFn;
  }

  void unsubscribe(String topic) {
    if (!_isConnected || _stompClient == null) {
      throw Exception('No se puede desuscribir: El WebSocket no está conectado');
    }

    // Buscamos si existe la función de desuscripción para ese tópico
    if (_subscriptions.containsKey(topic)) {
      // Ejecutamos la función para desuscribirnos
      _subscriptions[topic]!(unsubscribeHeaders: {});
      // La removemos de nuestro registro
      _subscriptions.remove(topic);
      debugPrint('✅ Desuscrito del tópico: $topic');
    } else {
      debugPrint('⚠️ No se encontró suscripción para el tópico: $topic');
    }
  }

  void disconnect() {
    // Desuscribirse de todos los tópicos activos antes de cerrar la conexión
    for (var unsubscribeFn in _subscriptions.values) {
      unsubscribeFn(unsubscribeHeaders: {});
    }
    _subscriptions.clear();

    _stompClient?.deactivate();
    _stompClient = null;
    _isConnected = false;
  }
}